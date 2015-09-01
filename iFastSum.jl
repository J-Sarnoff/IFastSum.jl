#=
   follows the algorithms as given in
   "Some Highly Accurate Basic Linear Algebra Subroutines"
   by Yuhang Zhao (c) 2010
   McMaster University, Hamilton, Canada

   except for Round3, where I have replaced
     a call to frexp with reinterpret logic

   comments are as they appear in the thesis
=#

rc = 0 # indicates if a recursive call of iFastSumAlgorithm occurs

function iFastSum{T<:Real}(x::Array{T,1})
    global rc;
    rc = 0
    n = length(x)
    xs = Array{T,1}(n) # iFastSumAlgorithm is destructive
    copy!(xs, x)       # thanks to Kristoffer Carlsson
    iFastSumAlgorithm(xs, n)
end

@inline function AddTwo{T<:Real}(a::T, b::T)
    x = a+b
    z = x-a
    y = (a-(x-z))+(b-z)
    (x,y)
end

@inline function Round3{T<:Real}(s0::T, s1::T, s2::T)
    # s,e = frexp(s1)
    # if (s!=0.5 || (sign(s1)!=sign(s2)))
    if (((reinterpret(UInt64,s1) & 0x000fffffffffffff) != zero(UInt64)) || (sign(s1) != sign(s2)))
        s0
    else
        1.1*s1 + s0
    end
end

# output: the correctly rounded sum of x
# for initial call, n is length of x
function iFastSumAlgorithm{T<:Real}(x::Array{T,1},n::Int)
    global rc
    s = zero(T); loop = 1; # loop counts the number of loops

    for i in 1:n # accumlate first approximation
        s,x[i] = AddTwo(s, x[i])
    end

    # main loop
    while true # loop forever
        # (1)
        count=1; st=zero(T); loop=loop+1; sm=zero(T)
        # count points to the next position in x to store the local error
        # st is the temporary sum
        # (2)
        for i in 1:n
            st,x[count] = AddTwo(st,x[i]) # x[count] is local error
            if x[count] != zero(T)
                count += 1
                sm = max(sm,abs(st))
            end
        end
        # (3)
        em = (count-1)*eps(sm)*0.5
        # each local error <= HalfUlp(sm)
        # em is the weak upper bound on magnitude of the sum of the errors
        # (4)
        s, st = AddTwo(s,st)
        st = x[count]
        n = count
        # (5)
        if (em==zero(T) || em < eps(s)*0.5)
            if rc > 0
                return s # return s if it is a recursive call
            end
            w1, e1 = AddTwo(st, em)
            w2, e2 = AddTwo(st, -em)
            if ((w1+s != s) | (w2+s != s)) || (Round3(s,w1,e1) != s) || (Round3(s,w2,e2) != s)
                re=1
                s1 = iFastSum(x,n) # first recursive call
                s,s1 = AddTwo(s,s1)
                s2 = iFastSum(x,n) # second recursive call
                re = 0
                s = Round3(s,s1,s2)
             end
             return s
        end
    end
end


