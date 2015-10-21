
# distutils: language = c++


from testclass cimport TestClass as TestClass_


cdef class TestClass:

    """ 
    Cython wrapper class for C++ class TestClass
    """

    cdef:
        TestClass_ *_thisptr

    def __cinit__(TestClass self):
        # Initialize the "this pointer" to NULL so __dealloc__
        # knows if there is something to deallocate. Do not 
        # call new TestClass() here.
        self._thisptr = NULL
        
    def __init__(TestClass self):
        # Constructing the C++ object might raise std::bad_alloc
        # which is automatically converted to a Python MemoryError
        # by Cython. We therefore need to call "new TestClass()" in
        # __init__ instead of __cinit__.
        self._thisptr = new TestClass_() 

    def __dealloc__(TestClass self):
        # Only call del if the C++ object is alive, 
        # or we will get a segfault.
        if self._thisptr != NULL:
            del self._thisptr
            
    cdef int _check_alive(TestClass self) except -1:
        # Beacuse of the context manager protocol, the C++ object
        # might die before TestClass self is reclaimed.
        # We therefore need a small utility to check for the
        # availability of self._thisptr
        if self._thisptr == NULL:
            raise RuntimeError("Wrapped C++ object is deleted")
        else:
            return 0    

    property x:
    
        # Here we use a property to expose the public member
        # x of TestClass to Python
        
        def __get__(TestClass self):
            self._check_alive()
            return self._thisptr.x
        
        def __set__(TestClass self, value):
            self._check_alive()
            self._thisptr.x = <int> value

    property y:
    
        # Here we use a property to expose the public member
        # y of TestClass to Python
    
        def __get__(TestClass self):
            self._check_alive()
            return self._thisptr.y
    
        def __set__(TestClass self, value):
            self._check_alive()
            self._thisptr.y = <int> value
            
            
    def Multiply(TestClass self, int a, int b):
        self._check_alive()
        return self._thisptr.Multiply(a,b)
            
    
    # The context manager protocol allows us to precisely
    # control the liftetime of the wrapped C++ object. del
    # is called deterministically and independently of 
    # the Python garbage collection.

    def __enter__(TestClass self):
        self._check_alive()
        return self
    
    def __exit__(TestClass self, exc_tp, exc_val, exc_tb):
        if self._thisptr != NULL:
            del self._thisptr 
            self._thisptr = NULL # inform __dealloc__
        return False # propagate exceptions



