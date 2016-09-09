-- rnd 2016 
-- fixed and adapted for minetest, added possibility of several variations in responses


------------------------------------------------------------------------
-- Joseph Weizenbaum's classic Eliza ported to SciTE Version 2
-- Kein-Hong Man <khman@users.sf.net> 20060905
-- This program is hereby placed into PUBLIC DOMAIN
------------------------------------------------------------------------

------------------------------------------------------------------------
-- Original ELIZA paper:
--   ELIZA--A Computer Program For the Study of Natural Language
--   Communication Between Man and Machine,
--   Joseph Weizenbaum, 1966, Communications of the ACM Volume 9,
--   Number 1 (January 1966): 36-35.
--   URL: http://i5.nyu.edu/~mm64/x52.9265/january1966.html

-- SETTINGS
local elizachatcharacter = " "; -- chat must begin with this character to trigger eliza response!
local elizatarget = ""; -- player with this name gets response from eliza when he talks

-- END OF SETTINGS


 -- randomly selected replies if no keywords
  local randReplies = {
    "what does that suggest to you?",
    "i see...",
    "i'm not sure i understand you fully.",
    "can you explain that?",
    "that is quite interesting!",
    "that's so interesting... please continue...",
    "i understand...",
    "well, well... do go on",
    "why are you saying that?",
    "please explain the background to that remark...",
    "could you say that again, in a different way?",
  }

  -- keywords, replies: if reply ends with something thats not a letter it wont transform sentence.
  
  local replies = {
	[" how to"] = {"@howto"}, -- this will trigger special response, useful to ask things like: how to craft apple?
	[" how do i"] = {"@howto"},
	
	[" hi"] = {"hello.", "hi.","hello, how are you today."},
	[" hello"] = {"hello.", "hi.","hello, how are you today."},
	[" can you"] = {"perhaps you would like to be able to","Don't you believe that I can","You want me to be able to"},
    [" do you"] = {"yes, i", "i dont always"},
    [" can i"] = {"Do you want to be able to","perhaps you don't want to be able to"},
    [" you are"] = {"what makes you think i am","Does it please you to believe I am","Perhaps you would like to be","Do you sometimes wish you were"},
    [" you're"] = {"what is your reaction to me being"},
    [" i don't"] = {"why don't you","Don't you really","Do you wish to be able to","Does that trouble you?"},
    [" i feel"] = {"tell me more about feelings","Do you often feel","Do you enjoy feeling"},
    [" why don't you"] = {"why would you want me to","Do you really believe I don't", "Perhaps in good time I will","Do you want me to"},
    [" why can't i"] = {"what makes you think you should be able to","Why can't you"},
    [" are you"] = {"why are you interested in whether or not i am","Would you prefer if I were not","Perhaps in your fantasies I am"},
    [" i can't"] = {"how do you know you can't","Have you tried?","Perhaps you can now"},
    [" sex"] = {"i feel you should discuss this with a human."},
    [" i am"] = {"how long have you been","Did you come to me because you are","How long have you been","Do you believe it is normal to be","Do you enjoy being"},
    [" i'm"] = {"how long have you been","Did you come to me because you are","How long have you been","Do you believe it is normal to be","Do you enjoy being"},
    [" i want"] = {"why do you want", "What would it mean to you if you got","Suppose you got","What if you never got",
	"I sometimes also want"},
    [" what"] = {
		"what do you think?","Why do you ask?","Does that question interest you?","What answer would please you the most?", "Are such questions on your mind often?",	"What is it that you really want to know?",
		"Have you asked anyone else?",	"Have you asked such questions before?", "What else comes to mind when you ask that?"
		},
    [" how"] = {
		"what do you think?","Why do you ask?","Does that question interest you?","What answer would please you the most?", "Are such questions on your mind often?",	"What is it that you really want to know?",
		"Have you asked anyone else?",	"Have you asked such questions before?", "What else comes to mind when you ask that?"
		},
    [" who"] = {
		"what do you think?","Why do you ask?","Does that question interest you?","What answer would please you the most?", "Are such questions on your mind often?",	"What is it that you really want to know?",
		"Have you asked anyone else?",	"Have you asked such questions before?", "What else comes to mind when you ask that?"
		},
    [" where"] = {
		"what do you think?","Why do you ask?","Does that question interest you?","What answer would please you the most?", "Are such questions on your mind often?",	"What is it that you really want to know?",
		"Have you asked anyone else?",	"Have you asked such questions before?", "What else comes to mind when you ask that?"
		},
    [" when"] = {
		"what do you think?","Why do you ask?","Does that question interest you?","What answer would please you the most?", "Are such questions on your mind often?",	"What is it that you really want to know?",
		"Have you asked anyone else?",	"Have you asked such questions before?", "What else comes to mind when you ask that?"
		},
    [" why"] = {
		"what do you think?","Why do you ask?","Does that question interest you?","What answer would please you the most?", "Are such questions on your mind often?",	"What is it that you really want to know?",
		"Have you asked anyone else?",	"Have you asked such questions before?", "What else comes to mind when you ask that?"
		},
	[" name"] = {"Names don't interest me.", "I don't care about names, please go on."},
	[" cause"] = {
		"Is that the real reason?",
		"Don't any other reasons come to mind?",
		"Does that reason explain anything else?",
		"What other reasons might there be?"
		},
	[" perhaps"] = {"you're not very firm on that!"},
    [" drink"] = {"moderation in all things should be the rule."},
    [" sorry"] = {
		"why are you apologizing?",
		"Please don't apologise!",
		"Apologies are not necessary.",
		"What feelings do you have when you apologise?",
		"Don't be so defensive!"
		},
    [" dream"] = {
	"why did you bring up the subject of dreams?",
	"What does that dream suggest to you?",
    "Do you dream often?";
    "What persons appear in your dreams?",
    "Are you disturbed by your dreams?"
	},
    [" i like"] = {"is it good that you like"},
    [" maybe"] = {
		"You don't seem quite certain.",
		"Why the uncertain tone?",
		"Can't you be more positive?",
		"You aren't sure?",
		"Don't you know?"
		},
    [" no"] = {
		"why are you being negative?",
		"Are you saying no just to be negative?",
		"You are being a bit negative.",
		"Why not?",
		"Are you sure?",
		"Why no?"		
		},
    [" your"] = {"why are you concerned about my","What about your own"},
    [" always"] = {
		"can you think of a specific example?",
		"When?",
		"What are you thinking of?",
		"Really, always?"
		},
    [" think"] = {
		"do you doubt",
		"Do you really think so?",
		"But you are not sure your",
		},
	[" alike"] = {
		"In what way?",
		"What resemblence do you see?",
		"What does the similarity suggest to you?",
		"What other connections do you see?",
		"Could there really be some connection?",
		"How?",
		"You seem quite positive."	
		},
    [" yes"] = {"you seem quite certain. why is this so?","Are you Sure?",
    "I see.","I understand."},
    [" friend"] = {
		"why do you bring up the subject of friends?",
		"Why do you bring up the topic of friends?",
		"Do your friends worry you?",
		"Do your friends pick on you?",
		"Are you sure you have any friends?",
		"Do you impose on your friends?",
		"Perhaps your love for friends worries you."
		},
    [" computer"] = {
	"why do you mention computers?",
	"Do computers worry you?",
    "Are you frightened by machines?",
    "What do you think machines have to do with your problems?",
    "Don't you think computers can help people?",
    "What is it about machines that worries you?"
	},
    [" am i"] = {"you are"},
	
  }

  -- conjugate
  local conjugate = {
    [" i "] = "you",
    [" are "] = "am",
    [" were "] = "was",
	[" was "] = "were",
    [" you "] = "me",
    [" your "] = "my",
	[" my "] = "your",
	[" mine "] = "your's",
	[" your's "] = "mine",
	[" myself "] = "yourself",
    [" i've "] = "you've",
    [" i'm "] = "you're",
    [" me "] = "you",
	[" you "] = "me",
    [" am i "] = "you are",
    [" am "] = "are",
  }

local information = {};


information.howto = function(text)

	local craft = function (text) -- will say out recipe to player
		
		local recipe = "";
		local searchlists = {minetest.registered_items,minetest.registered_nodes,minetest.registered_craftitems,minetest.registered_tools}
		local mkeylength = 99;
		local mrecipe = "";
		
		for _,list in ipairs(searchlists) do
			if recipe=="" then
				for key,_ in pairs(list) do
					if string.find(key,text) then 
						if string.len(key)<mkeylength then 
							mkeylength = string.len(key);
							
							recipe = minetest.get_craft_recipe(key);
						
							if recipe.type and recipe.items then
								recipe = "To make " .. key .. " do " .. recipe.type .. " recipe with ingredients " .. dump(recipe.items); 
								recipe = string.gsub(recipe, "\n", ""); -- remove newlines
								mrecipe = recipe;
							else
								recipe = "";
							end
						end
						
					end
				end
			end
		end
		
		if mrecipe == "" then mrecipe = "There is no craft item with the name " .. text end
		return mrecipe

	end

	local get = function (text) -- 
		local node = "";
		local mkeylength = 99;
		local y_max = -99999;
		local def;
		
		for _,v in pairs(minetest.registered_ores) do
		
			if string.find(v.ore,text) then 
				if string.len(v.ore)<=mkeylength then 
					mkeylength = string.len(v.ore);
					node = v.ore;
					def = v;
					if v.y_max and v.y_max<0 and v.y_max>y_max then y_max=v.y_max end
				end
			end
		end
		
		if y_max == -99999 then y_max = 0 end
		
		if node == "" then 
			node = "There is no material with that name. Perhaps you need to craft it?" 
		else
			
			if y_max<0 then
				node = "Full name of material is " .. node .. " You can find it if you dig down at least " .. -y_max .. " blocks ."
			else 
				if def.wherein then
					node = "Full name of material is " .. node .. " You can find it if you dig around in " .. dump(def.wherein);
				end
			end
		end
		
		return node;
	end

	local topic = {["craft"]=craft,["make"]=craft,["get"]=get,["find"]=get};
	
	-- process input
	for key,v in pairs(topic) do
		local i = string.find(text,key);
		if i then
			return v(string.sub(text,i+string.len(key)+1));
		end
	end
	
	return "";

end

  

local function Eliza(text)
  local response = ""
  local user = string.lower(text)
  local userOrig = user

 
  -- random replies, no keyword
  local function replyRandomly()
    response = randReplies[math.random(table.getn(randReplies))]; --.."\n"
  end

  -- find keyword, phrase
  local function processInput()
    for keyword, reply in pairs(replies) do
      local d, e = string.find(user, keyword, 1, 1) -- check user message keyword against list of keyword, reply pairs
  
	  reply = reply [ math.random(#reply) ] ; -- select random reply from many possibilities
	  
	  if d then
        
		if string.byte(reply,1) == 64 then -- @
			local info = information.howto(string.sub(user, e+1, -2)); 
			if info and info ~= "" then 
				response = info return 
			else
				
				replyRandomly()
				reply = response; response = "";
			end
		end
		
		-- process keywords
        response = response..reply.." "

        if string.byte(string.sub(reply, -1)) < 65 then -- not an alphabet character in response. return response!
          --response = response.."\n"; 
		  return response
        end
        
		local h = string.len(user) - (d + string.len(keyword))
        if h > 0 then
          user = string.sub(user, -h) -- remainder of user msg after phrase
        end
		
        for cFrom, cTo in pairs(conjugate) do -- do conjugate replacements on remainder
          local f, g = string.find(user, cFrom, 1, 1)
          if f then
            local j = string.sub(user, 1, f - 1).." "..cTo
            local z = string.len(user) - (f - 1) - string.len(cTo) -- again remainder length
            response = response..j; 
			
			if z > 2 then
              local l = string.sub(user, -(z - 1))
			  if l and not string.find(userOrig .. " ", l) then 
				return response 
			  end
            end
            if z > 2 then response = response.. " " .. string.sub(user, -(z - 1)) end 
            if z < 2 then response = response end
            return response
          end
        end
        response = response..user
        return response
      end
    end
	
	
    replyRandomly()
    return response
  end

  -- main()
  -- accept user input
  
  if string.sub(user, 1, 3) == "bye" then
    response = "bye, bye for now.\nsee you again some time."
	return response
  end
  if string.sub(user, 1, 7) == "because" then
    user = string.sub(user, 8)
  end
  user = " "..user.." "
   
  
  processInput()
   
  return response
end



local lastmessage;

minetest.register_on_chat_message(
function(name, message)

	if string.char(string.byte(message,1)) ~= elizachatcharacter and name~=elizatarget then return false end -- chat must begin with special character
	local response 
	if message == lastmessage then
		response = "Please don't repeat yourself!"
	else
		response = string.lower(Eliza(message));
	end
	lastmessage = message;
	
	local players = minetest.get_connected_players(); -- to prevent msg duplication
	for _,player in pairs(players) do
		local pname = player:get_player_name();
		if pname~=name then
			minetest.chat_send_player(pname,"<"..name .. "> " .. message);
		end
	end
	
	minetest.chat_send_all("<Eliza> " .. response)
	return true
end
)



minetest.register_chatcommand("elizatarget", {
	description = "",
	privs = {
		privs = true
	},
	func = function(name, param)
		elizatarget = param;
	end
});

	
-- http functionality
--package.path = package.path..";"..minetest.get_modpath("eliza").."/?.lua";
--package.cpath = package.cpath..";"..minetest.get_modpath("eliza").."/?.dll";
--local socket = require("socket.core") -- why does this crash server

--this works
--local tcp = package.loadlib(minetest.get_modpath("eliza").."/core.dll","tcp");
--print("eliza tcp loaded");
