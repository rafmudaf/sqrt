
import numpy as np
from ctypes import CDLL, POINTER, c_int, c_double

newtonraphsonlib = CDLL('./build/libnewtonraphson_fortran.dylib')

def test_int_2x():
    desired = 8
    actual = newtonraphsonlib.int_2x(4)
    np.testing.assert_almost_equal(actual, desired)


def test_int_sq():
    desired = 16
    actual = newtonraphsonlib.int_sq(4)
    np.testing.assert_almost_equal(actual, desired)

if __name__=="__main__":
    test_int_2x()
    test_int_sq()
