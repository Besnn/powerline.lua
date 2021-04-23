-- COLORDEX
----- Regular Text
text_black = "\x1b[30m"
text_red = "\x1b[31m"
text_green = "\x1b[32m"
text_yellow = "\x1b[33m"
text_blue = "\x1b[34m"
text_purple = "\x1b[35m"
text_cyan = "\x1b[36m"
text_white = "\x1b[37m"
----- Regular Background
bg_black = "\x1b[40m"
bg_red = "\x1b[41m"
bg_green = "\x1b[42m"
bg_yellow = "\x1b[43m"
bg_blue = "\x1b[44m"
bg_purple = "\x1b[45m"
bg_cyan = "\x1b[46m"
bg_white = "\x1b[47m"
----- High Intensity Text
hi_text_black = "\x1b[90m"
hi_text_red = "\x1b[91m"
hi_text_green = "\x1b[92m"
hi_text_yellow = "\x1b[93m"
hi_text_blue = "\x1b[94m"
hi_text_purple = "\x1b[95m"
hi_text_cyan = "\x1b[96m"
hi_text_white = "\x1b[97m"
---- High Intensity Backgrounds
hi_bg_black = "\x1b[100m"
hi_bg_red = "\x1b[101m"
hi_bg_green = "\x1b[102m"
hi_bg_yellow = "\x1b[103m"
hi_bg_blue = "\x1b[104m"
hi_bg_purple = "\x1b[105m"
hi_bg_cyan = "\x1b[106m"
hi_bg_white = "\x1b[107m"
---- Misc.
color_off = "\x1b[m"
bleach = color_off

-- SYMDEX
cap = ""
cap_sm = ""
branch_symbol = ""
space = " "
dollar_sign = "$"
question_marks = "??"
pencil = ""
question_mark = "?"
chevron_up = "ï„¹"
level_up = ""
ok = ""
modified = ""
null = "ﳠ"
chevron = "ï™"
base_next = bg_white
git_next = "ï…º"
windows_1 = ""
windows_2 = ""
windows_3 = ""
windows_4 = "者"
microsoft = ""
msdos = ""
revi = "ﰄ"
os_ = windows_4

symbol = revi

-- GLOBALS
branch = nl
commitNo = 0
notStagedNo = 0
untrackedNo = 0
base_next = ""
git_next = bg_white
commits_next = ""
notStaged_next = ""
untracked_next = ""

-- FORMATTING
base_bg = hi_bg_white
base_text = text_black
base_cap = hi_text_white..bg_white..cap
git_bg = bg_cyan
git_text = hi_text_white
git_cap = text_cyan..bg_white..cap
commits_bg = hi_bg_green
commits_text = hi_text_white
commits_cap = hi_text_white..cap
notStaged_bg = hi_bg_yellow
notStaged_text = text_black
notStaged_cap = bg_white..hi_text_yellow..cap
untracked_bg = hi_bg_yellow
untracked_text = text_red
untracked_cap = bg_white..hi_text_yellow..cap
end_bg = hi_text_white
end_text = text_black

-- PROMPT PROCESSING
local preprocessing = clink.promptfilter(30)
function preprocessing:filter(prompt)
    for line in io.popen("git branch 2>nul"):lines() do
        branch = line:match("%* (.+)$")
        if branch then
			base_cap = hi_text_white..git_bg..cap
        else
            base_next = bg_white
			branch = null
        end
    end

	for line in io.popen("git status --porcelain 2>nul"):lines() do
		local init = line:sub(1, 1)
		local second = line:sub(2, 2)
		if second == "M" then
			notStagedNo = notStagedNo + 1
		end
        if init == "M" or init == "R" or init == "D" or init == "A" then
            commitNo = commitNo + 1
        end
		if init == "?" then
			untrackedNo = untrackedNo + 1
		end
	end
	if commitNo > 0 then
		git_next = hi_bg_green
		git_cap = text_cyan..git_next..cap
	elseif notStagedNo > 0 then
		git_next = bg_yellow
		git_cap = text_cyan..git_next..cap
	elseif untrackedNo > 0 then
		git_next = hi_bg_yellow
		git_cap = text_cyan..git_next..cap
	else
		git_next = bg_white
		git_cap = text_cyan..git_next..cap
	end

	if notStagedNo > 0 then commits_cap = bg_yellow..hi_text_green..cap
	elseif untrackedNo > 0 then
		commits_cap = bg_yellow..hi_text_green..cap
	else
		commits_cap = bg_white..hi_text_green..cap
	end
	if untrackedNo > 0 then
		notStaged_cap = hi_bg_yellow..text_yellow..cap
	end
end


local base_prompt = clink.promptfilter(40)
function base_prompt:filter(prompt)
	return base_bg..base_text..space..os.getcwd()..bleach..base_cap
end

local git_prompt = clink.promptfilter(50)
function git_prompt:filter(prompt)
	if branch then
		return prompt..git_bg..git_text..space..branch_symbol..branch..space..git_cap
	else
		return prompt
	end
end

local git_commits = clink.promptfilter(60)
function git_commits:filter(prompt)
	if branch and commitNo > 0 then
		return prompt..commits_bg..commits_text..space..commitNo..level_up..space..commits_cap
	end
end

local git_notStaged = clink.promptfilter(70)
function git_notStaged:filter(prompt)
	if branch and notStagedNo > 0 then
		return prompt..notStaged_bg..notStaged_text..space..notStagedNo..pencil..space..notStaged_cap
	end
end

local git_untracked = clink.promptfilter(80)
function git_untracked:filter(prompt)
	if branch and untrackedNo > 0 then
		return prompt..untracked_bg..untracked_text..space..untrackedNo..question_mark..space..untracked_cap
	end
end

local end_prompt = clink.promptfilter(90)
function end_prompt:filter(prompt)
	return prompt..bg_white..text_black..space..symbol..space..bleach..text_white..cap..space
end
