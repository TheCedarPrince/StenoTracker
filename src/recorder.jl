"""
TODO: Add docstring
"""
function log_sessions(; db_name = "StenoTracker.db")
    log_exercise = true
    while log_exercise == true
        run(`clear`)
        println("Logging practice session.")

        date = Dates.format(now(), dateformat"YYYY-mm-dd")
        wpm = prompt("Input WPM")
        acc = prompt("Input Accuracy")
        ex = prompt("Input Exercise Name")

        db = SQLite.DB(db_name)

        DBInterface.execute(
            db,
            """INSERT INTO practice (`PRACTICE_DATE`, `WPM`, `ACC`, `EXERCISE`) VALUES("$(string(date))", $wpm, $acc, "$ex");""",
        )

        println("Practice session has been logged!")

        if "" != prompt("Nice work! 🌟 To record another session press ENTER!")
            log_exercise = false
        end
        
        run(`clear`)
        println("Great work and have an awesome day! 🌟")
    end
end

export log_sessions
