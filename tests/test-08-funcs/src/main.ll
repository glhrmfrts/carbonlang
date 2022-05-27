



(deftype file-handle int)

(deftype open-flags
    (enum-flags
        read
        write
        append
        create
        truncate))

(deftype my-data (struct
    ('value  int)
    ('value2 int)
    ('value3 int)))

(declf open (string int int) (tuple int error))

(defun open (path flags mode)
    ; cstr int int => int int
    (var buf (array 'byte 4096) (make-array 'byte 3 4 5 6 7))
    (let ((fd (syscall:open (to-cstr path buf) (to-kernel-flags flags) mode)))
        (if (< fd 0)
            (tuple 0 (errno-to-error fd))
            (tuple (cast file-handle fd) 0))))

(import
    io
    (k kernel))

(defmacro destructuring-bind (names) expr *body
  (assert (is-aggregate-type (type-of expr)))
  (emit (let ((temp [[expr]]))))
  (for-each name names
    (emit (let (([[name]] (temp [[field]])))))))

(defmacro init (type-name *args)
  (progn
    (declare val type-name)
    (for-each-indexed (i field) (type-fields (type-of t))
      (setf (val (field 'name)) (nth args i)))
    val))

(defun hello-world ()
  (format "Hello, World!\n"))

(defun main ()
  (destructuring-bind (file err) (k:open "nofile.txt" (open-flags 'read) 0)
    (if err
      (k:panic err)
      (destructuring-bind (stat err) (k:stat file)
        (if err
          (k:panic err)
          (let ((data (k:allocate-array 'byte (stat 'size))))
            (defer (k:free data))
            (k:read file data)
            (while (> (data 'length) 0)
              (destructuring-bind (left rest ok) (s:split-from-left data (char 10))
                (when ok
                  (destructuring-bind (num ok) (s:parse-int left)
                    (when ok
                      (incf sum num))))
                (setf data rest)))))))))