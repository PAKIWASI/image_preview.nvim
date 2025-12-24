
local M = {}

local oil

-- TODO: do tmux
local function in_tmux()
    if os.getenv('TMUX') ~= nil then
        return true
    else
        return false
    end
end


local function in_kitty()
    if os.getenv('KITTY_PID') ~= nil then
        return true
    else
        return false
    end
end

local function has_oil()
    local _has_oil, _oil = pcall(require, "oil")
    if (_has_oil) then
        oil = _oil
        return true
    else
        return false
    end
end


local function get_file_extention(url)
    return url:match("^.+(%..+)$")
end



function M.is_image(url)
    local extension = get_file_extention(url)

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

function M.preview_image(absolutePath)

    if M.is_image(absolutePath) then
        -- TODO: check if correct
        vim.api.nvim_cmd(
            { cmd = "kitty +kitten icat", args = { absolutePath } },
            { output = true }
        )
    else
        print("No preview for file " .. absolutePath)
    end
end


function M.preview_image_oil()
    local entry = oil.get_cursor_entry()

    if (entry and entry['type'] == 'file') then
        local dir = oil.get_current_dir()
        local fileName = entry['name']
        local fullName = dir .. fileName

        M.preview_image(fullName)
    end
end

function M.setup()

    local command =
    "au Filetype oil nmap <buffer> <silent> <leader>p :lua require('image_preview').PreviewImageOil()<cr>"
    vim.api.nvim_command(command)
end

return M



