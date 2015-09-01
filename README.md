# IFastSum.jl
#### correctly rounded summation (Yuhang Zhao's iFastSum)

####use:  

sum_of_xs = iFastSum(x::Vector{AbstractFloat})

####notes:

This should work correctly for vectors of any size.  The time used relative to sum() is somewhat host dependant.  On one machine, I found it likely to range from ~2x (500 values) to ~4x-~6x (25_000 values) to ~9x-~12x (10_000_000 values). To get accurate relative timings, I used @CPUelapsed from CPUTime in a loop that looked for the shortest time.

####reference:

"Some Highly Accurate Basic Linear Algebra Subroutines"
by Yuhang Zhao (c) 2010
McMaster University, Canada
