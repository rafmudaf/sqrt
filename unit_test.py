
import sys
import numpy as np
from ctypes import (
    CDLL,
    POINTER,
    c_int,
    c_float,
    c_double,
    c_char_p,
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

    def __str__(self):
        string = f"{self.array_len} - "
        for i in range(self.array_len):
            string += "{:<8.2f}".format(self.array[i])
        return string


class array2d_container(Structure):
    # _pack_ = True # source:False
    _fields_ = [
        ('array', POINTER(array_container)),
        ('array_len', c_int)
    ]


if __name__ == "__main__":

    newtonraphsonlib.array_passing.argtypes = [
        POINTER(array_container),
        POINTER(array_container),
        c_char_p
    ]
    newtonraphsonlib.array_passing.restypes = c_int

    newtonraphsonlib.array_passing2d.argtypes = [
        POINTER(array2d_container),
        POINTER(array2d_container)
    ]
    newtonraphsonlib.array_passing2d.restypes = c_int

    # Pass a single array and get it back
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
        byref(array_out),
        c_char_p(b"abcd")
    )
    print(f"Returned with response code: {return_code}")

    print(array_out)

    # Nested arrays - array of arrays
    array_temp1 = array_container(
        (n_inputs * c_float)(1.1, 2.2, 3.3, 4.4, 5.5, 6.6),
        c_int(n_inputs)
    )
    array_temp2 = array_container(
        (n_inputs * c_float)(7.7, 8.8, 9.9, 11.0, 12.1, 13.2),
        c_int(n_inputs)
    )
    array_in = array2d_container(
        (2 * array_container)(array_temp1, array_temp2),
        c_int(2)
    )

    array_out = array2d_container()

    print("Calling Fortran library...")
    return_code = newtonraphsonlib.array_passing2d(
        byref(array_in),
        byref(array_out)
    )
    print(f"Returned with response code: {return_code}")

    for i in range(array_out.array_len):
        print(array_out.array[i])
