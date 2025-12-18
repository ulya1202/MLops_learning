from add_function import addition


def test_addition():
    assert addition(2, 3) == 4


if __name__ == "__main__":
    test_addition()
    print("All tests passed!")
