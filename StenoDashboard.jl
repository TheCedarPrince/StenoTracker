using DataFrames
using DBInterface
using FunSQL
using FunSQL: From, Get, Group, Select, render, reflect
using Genie, Stipple, StippleUI
using Genie.Renderers.Html
using PlotlyBase
using SQLite
using Statistics
using Stipple
using StipplePlotly
using StipplePlotly: PlotLayout, PlotConfig
using StippleUI

db = DBInterface.connect(SQLite.DB, "steno.db")
table_info = reflect(db).tables

practice = table_info[:practice]

practice_data =
    From(practice) |> FunSQL.render |> sql -> DBInterface.execute(db, sql) |> DataFrame

practice_data.PRACTICE_DATE = Dates.Date.(practice_data.PRACTICE_DATE)
sort!(practice_data, :PRACTICE_DATE)

pd(; x, y) = PlotData(x = x, y = y, plot = StipplePlotly.Charts.PLOT_TYPE_LINE)

@reactive mutable struct Model <: ReactiveModel
    wpm_data::R{Vector{Vector{PlotData}}} = [[
        pd(
            x = unique(group.PRACTICE_DATE) , 
            y = [mean(g.WPM) for g in groupby(group, :PRACTICE_DATE)],
        ) for group in groupby(practice_data, :EXERCISE)
    ]]
    wpm_layout::R{Vector{PlotLayout}} = [
        PlotLayout(
            title = PlotLayoutTitle(text = "$(group.EXERCISE |> first)", font = Font(24)),
            xaxis = [PlotLayoutAxis(xy = "x", title_text = "Date", font = Font(14))],
            yaxis = [
                PlotLayoutAxis(xy = "y", title_text = "Average Words Per Minute", font = Font(14)),
            ],
            showlegend = false,
            margin_r = 0,
        ) for group in groupby(practice_data, :EXERCISE)
    ]

    acc_data::R{Vector{Vector{PlotData}}} = [[
        pd(
            x = unique(group.PRACTICE_DATE) , 
            y = [mean(g.ACC) for g in groupby(group, :PRACTICE_DATE)],
        ) for group in groupby(practice_data, :EXERCISE)
    ]]
    acc_layout::R{Vector{PlotLayout}} = [
        PlotLayout(
            title = PlotLayoutTitle(text = "$(group.EXERCISE |> first)", font = Font(24)),
            xaxis = [PlotLayoutAxis(xy = "x", title_text = "Date", font = Font(14))],
            yaxis = [
                PlotLayoutAxis(xy = "y", title_text = "Average Session Accuracy", font = Font(14)),
            ],
            showlegend = false,
            margin_r = 0,
        ) for group in groupby(practice_data, :EXERCISE)
    ]

end

function handlers(model)
    on(model.isready) do isready
        isready || return
        push!(model)
    end

    model
end

function ui(model::Model)
    page(
        model,
        class = "container",
        [
            row([h1("Stenography Practice Results")])
            row([
                cell(
                    class = "st-module",
                    [plot("wpm_data[index-1]", layout = "wpm_layout[index-1]")],
                    @recur("index in $(length(model.wpm_data[]))")
                ),
            ])
            row([
                cell(
                    class = "st-module",
                    [plot("acc_data[index-1]", layout = "acc_layout[index-1]")],
                    @recur("index in $(length(model.acc_data[]))")
                ),
            ])
        ],
    )
end

model = init(Model)
route("/") do
    model |> handlers |> ui |> html
end

up(8000)

