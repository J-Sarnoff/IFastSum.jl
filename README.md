# IFastSum.jl
#### correctly rounded summation (Yuhang Zhao's iFastSum)

####use:  

sum_of_xs = iFastSum(x::Vector{AbstractFloat})

####notes:

This should work correctly for vectors of any size.  The time used relative to sum() is somewhat host dependant.  On one machine, I found it likely to range from ~2x (500 values) to ~3x-~5x (25_000 values) to ~9x-~11x (10_000_000 values).

####reference:

"Some Highly Accurate Basic Linear Algebra Subroutines"
by Yuhang Zhao (c) 2010
McMaster University, Canada
