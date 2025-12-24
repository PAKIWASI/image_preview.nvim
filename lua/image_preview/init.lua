local M = {}


local function GetFileExtension(url)
    return url:match("^.+(%..+)$")
end


local function is_kitty()
    if os.getenv('KITTY_PID') ~= nil then
        return true
    else
        return false
    end
end

function M.IsImage(url)
    local extension = GetFileExtension(url)

    if extension == '.bmp' then
        return true
    elseif extension == '.jpg' or extension == '.jpeg' then
        return true
    elseif extension == '.png' then
        return true
    elseif extension == '.gif' then
        return true
    end

    return false
end

function M.PreviewImage(absolutePath)

    if M.IsImage(absolutePath) then
        -- TODO: check if correct
        vim.api.nvim_cmd(
            { cmd = "kitty +kitten icat", args = { absolutePath } },
            { output = true }
        )
    else
        print("No preview for file " .. absolutePath)
    end
end


function M.PreviewImageOil()
    local use, imported = pcall(require, "oil")
    if use then
        local entry = imported.get_cursor_entry()

        if (entry and entry['type'] == 'file') then
            local dir = imported.get_current_dir()
            local fileName = entry['name']
            local fullName = dir .. fileName

            M.PreviewImage(fullName)
        end
    else
        return ''
    end
end

function M.setup()

    local command =
    "au Filetype oil nmap <buffer> <silent> <leader>p :lua require('image_preview').PreviewImageOil()<cr>"
    vim.api.nvim_command(command)
end

return M
