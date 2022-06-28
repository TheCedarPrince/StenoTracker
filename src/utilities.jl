using Base: prompt
using SQLite

function empty_database!(db_name = "steno.db")
    db = SQLite.DB(db_name)

    choice = prompt(
        "This is a PERMANENT action and will completely delete all entries in your database. Are you sure you want to proceed? (Y/N)",
    )

    if choice == lowercase("Y")
        DBInterface.execute(db, """DELETE FROM practice;""")
        println("Database has been emptied!")
    else
        println("Database has NOT been emptied!")
    end

end
