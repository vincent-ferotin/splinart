"""Tests of :mod:`respline` shapes."""

import pytest
from pytest import approx

import numpy as np

from splinart import circle


@pytest.fixture()
def zero_center() -> list[float]:
    """Fixture setting circle center to zero.

    Returns
    -------
    `list[float]`
        Coordinates of zero for center

    """
    return [0.0, 0.0]


@pytest.fixture()
def unit_radius() -> float:
    """Fixture setting circle radius to unit size.

    Returns
    -------
    `int`
        Unit size for circle radius.

    """
    return 1.0


@pytest.mark.parametrize(
    "points_nb, expected_path",
    [
        (2, [[1.0, 0.0], [1.0, 0.0]]),
        (5, [[1.0, 0.0], [0.0, 1.0], [-1.0, 0.0], [0.0, -1.0], [1.0, 0.0]]),
    ],
)
def test_simple_circle(
    zero_center: list[float],
    unit_radius: float,
    points_nb: int,
    expected_path: list[list[float]],
) -> None:
    """Test simple circle.

    Parameters
    ----------
    zero_center : float
        Center of circle to zero.
    unit_radius : float
        Radius of circle of unit size.
    points_nb : int
        Number of points on the circle.
    expected_path : list[list[float]]
        Coordinates of points on circle.

    """
    result_path: np.array
    _, result_path = circle(center=zero_center, radius=unit_radius, npoints=points_nb)

    assert result_path.tolist() == approx(np.array(expected_path), rel=1e-5)
