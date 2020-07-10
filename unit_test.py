
import sys
import numpy as np
from ctypes import (
    CDLL,
    POINTER,
    c_int,
    c_float,
    c_double,
    Structure,
    pointer,
    byref
)

if sys.platform == "darwin":
    library_extension = "dylib"
elif sys.platform == "linux":
    library_extension = "so"
elif sys.platform == "win32":
    library_extension = "dll"
# elif sys.platform == "cygwin":
# ??
#     library_extension = "dll"

newtonraphsonlib = CDLL('./build/libnewtonraphson_fortran.{}'.format(library_extension))

class array_container(Structure):
    # _pack_ = True # source:False
    _fields_ = [
        ('array', POINTER(c_float)),
        ('array_len', c_int)
    ]

if __name__ == "__main__":

    newtonraphsonlib.array_passing.argtypes = [
        POINTER(array_container),
        POINTER(array_container)
    ]
    newtonraphsonlib.array_passing.restypes = c_int

    n_inputs = 6
    n_outputs = 6
    array_in = array_container(
        (n_inputs * c_float)(1.1, 2.2, 3.3, 4.4, 5.5, 6.6),
        c_int(n_inputs)
    )

    array_out = array_container()

    print("Calling Fortran library...")
    return_code = newtonraphsonlib.array_passing(
        byref(array_in),
        byref(array_out)
    )
    print(f"Returned with response code: {return_code}")

    print(array_out.array_len)
    for i in range(n_outputs):
        print(f"{i}: {array_out.array[i]}")
