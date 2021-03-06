(module tests-book mzscheme
  
  (provide tests-for-run tests-for-check tests-for-parse)
  ;;;;;;;;;;;;;;;; tests ;;;;;;;;;;;;;;;;

  (define the-test-suite
 
    '(

      (modules-dans-simplest "
         module m1
          interface 
           [a : int
            b : int]
          body
           [a = 33
            c = -(a,1)
            b = -(c,a)]

         let a = 10
         in -(-(from m1 take a, from m1 take b), 
              a)"
        int 24)


      (example-8.2 "
         module m1 
          interface 
           [u : bool]
          body 
           [u = 33]

         44"
        error 44)

      (example-8.3 "
         module m1 
          interface 
           [u : int 
            v : int]
          body 
           [u = 33]

         44"
        error)

      (example-8.4 "
         module m1 
          interface 
           [u : int 
            v : int] 
          body 
           [v = 33 
            u = 44]

         from m1 take u" 
        error)

      (example-8.5a "
         module m1 
          interface 
           [u : int] 
          body 
           [u = 44]

         module m2 
          interface
           [v : int] 
          body 
           [v = -(from m1 take u,11)]

         -(from m1 take u, from m2 take v)"
        int)

      (example-8.5b "
         module m2 
          interface [v : int] 
          body 
           [v = -(from m1 take u,11)]

         module m1 
          interface [u : int] 
          body [u = 44]

         -(from m1 take u, from m2 take v)"
        error)

      (example-8.10"
       module m1 
       interface 
        [transparent t = int 
         z : t
         s : (t -> t)
         is-z? : (t -> bool)]
       body 
        [type t = int
         z = 0
         s = proc (x : t) -(x,-1)
         is-z? = proc (x : t) zero?(x)]

      let foo = proc (z : from m1 take t) 
                 -(0, (from m1 take s 
                       z))
      in
      (foo 
       from m1 take z)"
        int -1)

      (example-8.14 "
         module m1 
       interface [transparent t = int
                  z : t]
       body [type t = int
                       z = 0]
      module m2 
       interface 
        [foo : (from m1 take t -> int)]
       body 
        [foo = proc (x : from m1 take t) x]

      from m2 take foo"
        (int -> int))

      (example-8.15 "
         module m1 
       interface 
        [opaque t
         z : t
         s : (t -> t)
         is-z? : (t -> bool)]
       body 
        [type t = int
         z = 0
         s = proc (x : t) -(x,-1)
         is-z? = proc (x : t) zero?(x)]

      let foo = proc (z : from m1 take t) 
                 (from m1 take s 
                  (from m1 take s
                   z))
      -(0, (foo 
            from m1 take z))"
        error)

      (example-8.15a "
      module m1 
       interface 
        [opaque t
         z : t
         s : (t -> t)
         is-z? : (t -> bool)]
       body 
        [type t = int
         z = 0
         s = proc (x : t) -(x,-1)
         is-z? = proc (x : t) zero?(x)]

      let foo = proc (z : from m1 take t) 
                 (from m1 take s
                  z)
      in (foo 
       from m1 take z)"
        (from m1 take t))

      (example-8.8 "
         module colors
         interface
          [opaque color
           red : color
           green : color
           is-red? : (color -> bool)
           switch-colors : (color -> color)]
         body
          [type color = int
           red = 0
           green = 1
           is-red? = proc (c : color) zero?(c)
           switch-colors = proc (c : color) 
                            if (is-red? c) then green else red]

         44"
        int)

      (example-8.9 "
         module ints-1
         interface [opaque t
                    zero : t
                    succ : (t -> t)
                    pred : (t -> t)
                    is-zero : (t -> bool)]  
         body [type t = int
                         zero = 0
                         succ = proc(x : t) -(x,-5)
                         pred = proc(x : t) -(x,5)
                         is-zero = proc (x : t) zero?(x)]

         let zero = from ints-1 take zero
         in let succ = from ints-1 take succ
         in (succ (succ zero))"
        (from ints-1 take t) 10)

      (example-8.10 "
         module ints-2
         interface [opaque t
                    zero : t
                    succ : (t -> t)
                    pred : (t -> t)
                    is-zero : (t -> bool)]  
         body [type t = int
                         zero = 0
                         succ = proc(x : t) -(x,3)
                         pred = proc(x : t) -(x,-3)
                         is-zero = proc (x : t) zero?(x)]

         let z = from ints-2 take zero
         in let s = from ints-2 take succ
         in (s (s z))"
        (from ints-2 take t) -6)

      (example-8.11 "
         module ints-1
         interface [opaque t
                    zero : t
                    succ : (t -> t)
                    pred : (t -> t)
                    is-zero : (t -> bool)]  
         body [type t = int
                         zero = 0
                         succ = proc(x : t) -(x,-5)
                         pred = proc(x : t) -(x,5)
                         is-zero = proc (x : t) zero?(x)]
        let z = from ints-1 take zero
        in let s = from ints-1 take succ
        in let p = from ints-1 take pred
        in let z? = from ints-1 take is-zero
        in letrec int to-int (x : from ints-1 take t) =
                      if (z? x) then 0
                         else -((to-int (p x)), -1)
        in (to-int (s (s z)))"
        int 2)

      (example-8.12 "
         module ints-2
         interface [opaque t
                    zero : t
                    succ : (t -> t)
                    pred : (t -> t)
                    is-zero : (t -> bool)]  
         body [type t = int
                         zero = 0
                         succ = proc(x : t) -(x,3)
                         pred = proc(x : t) -(x,-3)
                         is-zero = proc (x : t) zero?(x)
                         ]

         let z = from ints-2 take zero
         in let s = from ints-2 take succ
         in let p = from ints-2 take pred
         in let z? = from ints-2 take is-zero
         in letrec int to-int (x : from ints-2 take t) =
                       if (z? x) then 0
                          else -((to-int (p x)), -1)
         in (to-int (s (s z)))"
        int 2)

      (example-8.13 "
         module mybool 
          interface [opaque t
                     true : t
                     false : t
                     and : (t -> (t -> t))
                     not : (t -> t)
                     to-bool : (t -> bool)]
          body [type t = int
                          true = 0
                          false = 13
                          and = proc (x : t) 
                                 proc (y : t)
                                  if zero?(x) 
                                   then y 
                                   else false
                          not = proc (x : t) 
                                 if zero?(x) 
                                  then false 
                                  else true
                          to-bool = proc (x : t) zero?(x)] 

         let true = from mybool take true
         in let false = from mybool take false
         in let and = from mybool take and
         in ((and true) false)"
        (from mybool take t) 13)

;;       (exercise-8.15 "
;;          module tables
;;          interface [opaque table
;;                     empty : table
;;                     add-to-table : (int -> (int -> (table -> table)))
;;                     lookup-in-table : (int -> (table -> int))]
;;          body
;;           [type table = (int -> int)
;;            ...  % to be filled in for exercise 8.15
;;            ]

;;           let empty = from tables take empty
;;           in let add-binding = from tables take add-to-table
;;           in let lookup = from tables take lookup-in-table
;;           in let table1 = (((add-binding 3) 301)
;;                            (((add-binding 4) 400)
;;                             (((add-binding 3) 301)
;;                               empty)))
;;           in -( ((lookup 4) table1),
;;                 ((lookup 3) table1))"
;;         int 99)

      (exercise-8.14 "
         module mybool 
         interface [opaque t
                    true : t
                    false : t
                    and : (t -> (t -> t))
                    not : (t -> t)
                    to-bool : (t -> bool)]
         body [type t = int
                         true = 1
                         false = 0
                         and = proc (x : t) 
                                proc (y : t)
                                 if zero?(x) 
                                  then false 
                                  else y
                         not = proc (x : t) 
                                if zero?(x) 
                                 then true 
                                 else false
                         to-bool = proc (x : t) 
                                    if zero?(x) 
                                     then zero?(1) 
                                     else zero?(0)]
          44"
        int 44)

 
      ))

  (define tests-for-run
    (let loop ((lst the-test-suite))
      (cond
        ((null? lst) '())
        ((= (length (car lst)) 4)
         ;; (printf "creating item: ~s~%" (caar lst))
         (cons
           (list
             (list-ref (car lst) 0)
             (list-ref (car lst) 1)
             (list-ref (car lst) 3))
           (loop (cdr lst))))
        (else (loop (cdr lst))))))

  ;; ok to have extra members in a test-item.
  (define tests-for-check the-test-suite)

  (define tests-for-parse the-test-suite)

  )

