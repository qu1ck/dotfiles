local msg = require 'mp.msg'

function show_current_filename()
    local filename = mp.get_property("filename")
    if filename then
        mp.osd_message("Current file: " .. filename, 3) -- Display for 3 seconds
    else
        mp.osd_message("No file loaded.", 2)
    end
end

mp.register_event("file-loaded", show_current_filename)

function chapter_seek(direction)
    msg.info("chapter_seek called with direction: " .. direction)
    local chapters = mp.get_property_number("chapters")
    if chapters == 0 then
        -- No chapters, go to next/prev playlist item
        if direction > 0 then
            mp.command("playlist-next")
        else
            mp.command("playlist-prev")
        end
        mp.set_property("pause", "no")
    else
        -- Chapters are available
        local chapter = mp.get_property_number("chapter")
        if chapter + direction < 0 then
            mp.command("playlist-prev")
            mp.set_property("pause", "no")
        elseif chapter + direction >= chapters then
            mp.command("playlist-next")
            mp.set_property("pause", "no")
        else
            mp.commandv("add", "chapter", direction)
        end
    end
end
mp.add_key_binding("PGDWN", "chapter_next", function() chapter_seek(1) end)
mp.add_key_binding("PGUP", "chapter_prev", function() chapter_seek(-1) end)
