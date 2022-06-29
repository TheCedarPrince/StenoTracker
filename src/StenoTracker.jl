module StenoTracker

using Base: prompt, run
using DataFrames
using Dates
using SQLite

# TODO: Look into submodule for Genie dashboard
include("utilities.jl")
include("recorder.jl")

end
