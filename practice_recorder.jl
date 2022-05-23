using Base: prompt, run
using Dates
using SQLite

log_exercise = true
while log_exercise == true
    run(`clear`)
    println("Logging practice session.")

    date = Dates.format(now(), dateformat"YYYY-mm-dd")
    wpm = prompt("Input WPM")
    acc = prompt("Input Accuracy")
    ex = prompt("Input Exercise Name")

    db = SQLite.DB("steno.db")

    DBInterface.execute(
        db,
        """INSERT INTO practice (`PRACTICE_DATE`, `WPM`, `ACC`, `EXERCISE`) VALUES("$(string(date))", $wpm, $acc, "$ex");""",
    )

    println("Practice session has been logged!")

    if "" != prompt("To input another practice session press ENTER")
        log_exercise = false
    end
end

println("You're doing great!")
