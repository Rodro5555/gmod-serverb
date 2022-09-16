if CLIENT then
    slib.setLang("sreward", "en", "general", "General")
    slib.setLang("sreward", "en", "submit", "Submit")
    slib.setLang("sreward", "en", "tasks", "Tasks")
    slib.setLang("sreward", "en", "referral", "Referral")
    slib.setLang("sreward", "en", "shop", "Shop")
    slib.setLang("sreward", "en", "leaderboard", "Leaderboard")
    slib.setLang("sreward", "en", "coupons", "Coupons")

    slib.setLang("sreward", "en", "main_title", "sReward - Reward System")
    slib.setLang("sreward", "en", "title_admin", "sReward - Admin")

    slib.setLang("sreward", "en", "rewards_title", "%s - Rewards")
    slib.setLang("sreward", "en", "coupon_title", "Coupons")

    slib.setLang("sreward", "en", "coupon_receive_title", "New coupon!")
    slib.setLang("sreward", "en", "coupon_receive", "You have received a new coupon, \n    check your coupon inventory!") --- Had to fine tune like that :(

    slib.setLang("sreward", "en", "copied_clipboard", "Copied to clipboard!")
    slib.setLang("sreward", "en", "no_coupons", "You have no coupons!")
    slib.setLang("sreward", "en", "no_rewards", "There are no rewards!")

    slib.setLang("sreward", "en", "delete", "Delete")
    slib.setLang("sreward", "en", "yes", "Yes")
    slib.setLang("sreward", "en", "no", "No")

    slib.setLang("sreward", "en", "top_3", "Top 3")

    slib.setLang("sreward", "en", "you", "You")
    slib.setLang("sreward", "en", "friend", "Friend")

    slib.setLang("sreward", "en", "referr_with_code", "Referr with code")

    slib.setLang("sreward", "en", "are_you_sure", "Are you sure?")
    slib.setLang("sreward", "en", "manage", "Manage")

    slib.setLang("sreward", "en", "tokens", "Tokens")
    slib.setLang("sreward", "en", "select_reward", "Select Reward")
    slib.setLang("sreward", "en", "number", "Number")

    slib.setLang("sreward", "en", "submit", "Submit")
    slib.setLang("sreward", "en", "name", "Name")
    slib.setLang("sreward", "en", "uses", "Uses")
    slib.setLang("sreward", "en", "used", "Used")
    slib.setLang("sreward", "en", "task", "Task")
    slib.setLang("sreward", "en", "verify", "Verify")
    slib.setLang("sreward", "en", "total_tokens", "Total Tokens")
    slib.setLang("sreward", "en", "referrals", "Referrals")

    slib.setLang("sreward", "en", "rewards", "Rewards")
    slib.setLang("sreward", "en", "price", "Price")
    slib.setLang("sreward", "en", "imgur_id", "Imgur ID")

    slib.setLang("sreward", "en", "edit_rewards", "Edit Rewards")
    slib.setLang("sreward", "en", "save", "Save")

    slib.setLang("sreward", "en", "insert_imgur_id", "Insert Imgur ID")
    slib.setLang("sreward", "en", "insert_name", "Insert Name")
    slib.setLang("sreward", "en", "insert_price", "Insert Price")

    slib.setLang("sreward", "en", "create_coupon", "Create Coupon")
    slib.setLang("sreward", "en", "coupon_name", "Coupon Name")

    slib.setLang("sreward", "en", "create_shopitem", "Create Shop Item")
    slib.setLang("sreward", "en", "item_name", "Item Name")

    slib.setLang("sreward", "en", "this_will_cost", "'%s' will cost you %s tokens!")
    slib.setLang("sreward", "en", "coupon_delete_confirm", "This will delete coupon '%s'?")
    slib.setLang("sreward", "en", "this_delete", "This will delete '%s'")
    slib.setLang("sreward", "en", "no_data", "No data")

    slib.setLang("sreward", "en", "manage_item", "Manage Item")

    slib.setLang("sreward", "en", "discord_failed_application_com", "We failed communicating with your discord application, make sure it is running!")
    slib.setLang("sreward", "en", "discord_error_retrieving_data", "We encountered an issue while retrieving data from discord, please inform staff about this!")
else
    slib.setLang("sreward", "en", "cooldown", "You are on a verification cooldown, please wait %s seconds!")

    slib.setLang("sreward", "en", "added_queue", "You have been added to the queue for '%s' checkup, you will receive a response within %s seconds!")

    slib.setLang("sreward", "en", "added_steamgroup_queue", "You have been added to the queue for steamgroup check, you will receive a response within %s seconds!")
    slib.setLang("sreward", "en", "didnt_find_steamgroup", "We could not find you in the steamgroup, please try again!")
    slib.setLang("sreward", "en", "failed_verification", "Looks like we failed to verify reward '%s', make sure to complete the task properly.")
    
    slib.setLang("sreward", "en", "discord_error_retrieving_data", "We were unsuccessfull in contacting discord, please try again later!")
    slib.setLang("sreward", "en", "checking_wait", "Please wait while we verify reward '%s' for you!")

    slib.setLang("sreward", "en", "steam_unsuccessfull", "We were unsuccessfull in contacting steam, please try again later!")
    slib.setLang("sreward", "en", "steam_private", "We failed checking your steam groups, make sure that your profile is public so we can check!")
    slib.setLang("sreward", "en", "success_reward", "You have received the '%s' reward!")

    slib.setLang("sreward", "en", "already_referred", "You have already referred this person!")
    slib.setLang("sreward", "en", "referral_limit", "You have reached the max referral limit!")
    slib.setLang("sreward", "en", "referred_person", "You have received a reward for setting %s as your referee!")
    slib.setLang("sreward", "en", "referred_by", "You have received a reward for referring %s!")
    slib.setLang("sreward", "en", "referring_person", "You have received a reward for referring a person!")
    slib.setLang("sreward", "en", "cannot_referr_again", "You cannot referr this person again!")
    slib.setLang("sreward", "en", "raferring_ratelimit", "You have been ratelimited, wait for your first referral request to finish!")

    slib.setLang("sreward", "en", "mysql_successfull", "We have successfully connected to the database!")
    slib.setLang("sreward", "en", "mysql_failed", "We have failed connecting to the database!")
    slib.setLang("sreward", "en", "cannot_afford", "You cannot afford this!")
    slib.setLang("sreward", "en", "successfull_purchase", "You have succesfully purchased '%s'!")

    slib.setLang("sreward", "en", "taken_tokens", "Someone has taken %s tokens from you, Your balance is %s!")
    slib.setLang("sreward", "en", "given_tokens", "Someone has given %s tokens to you, Your balance is %s!")
    slib.setLang("sreward", "en", "given_reward", "Someone has given you the reward '%s'!")

    slib.setLang("sreward", "en", "performed_admin_action", "You have performed admin action towards '%s' with value of '%s'")
    slib.setLang("sreward", "en", "coupon_out_of_stock", "We are currently out of stock for '%s' coupons, please contact higher ups so we can restock!")
end

slib.setLang("sreward", "en", "on_cooldown", "You are on a cooldown wait %s seconds to use this reward again!")

slib.setLang("sreward", "en", "max_use_reached", "You have reached the max use limit of this reward!")

slib.setLang("sreward", "en", "sr_tokens", "sR Tokens")

slib.setLang("sreward", "en", "darkrp_money", "DarkRP Money")

slib.setLang("sreward", "en", "reward_rank", "Rank")

slib.setLang("sreward", "en", "coupon", "Coupon")

slib.setLang("sreward", "en", "give_weapon", "Give Weapon")

slib.setLang("sreward", "en", "basewars_money", "Basewars Money")
slib.setLang("sreward", "en", "basewars_level", "Basewars Level")

slib.setLang("sreward", "en", "vrondakis_level", "Level")
slib.setLang("sreward", "en", "vrondakis_xp", "XP")

slib.setLang("sreward", "en", "glorified_level", "Level")
slib.setLang("sreward", "en", "glorified_xp", "XP")

slib.setLang("sreward", "en", "essentials_level", "Level")
slib.setLang("sreward", "en", "essentials_xp", "XP")

slib.setLang("sreward", "en", "elite_xp", "XP")
slib.setLang("sreward", "en", "elevel_xp", "XP")

slib.setLang("sreward", "en", "elevel_xp", "XP")

slib.setLang("sreward", "en", "wos_level", "wOS Level")
slib.setLang("sreward", "en", "wos_xp", "wOS XP")
slib.setLang("sreward", "en", "wos_points", "wOS Points")
slib.setLang("sreward", "en", "wos_giveitem", "wOS Give item")

slib.setLang("sreward", "en", "ps1_points", "PS1 Points")

slib.setLang("sreward", "en", "ps2_standard_points", "PS2 Standard Points")
slib.setLang("sreward", "en", "ps2_premium_points", "PS2 Premium Points")

slib.setLang("sreward", "en", "sh_ps_standard_points", "SH PS Standard Points")
slib.setLang("sreward", "en", "sh_ps_premium_points", "SH PS Premium Points")

slib.setLang("sreward", "en", "give_tokens", "Give Tokens")
slib.setLang("sreward", "en", "give_reward", "Give Reward")
slib.setLang("sreward", "en", "take_tokens", "Take Tokens")

slib.setLang("sreward", "en", "invalid_sid64", "Invalid SteamID64")
slib.setLang("sreward", "en", "cannot_referr_yourself", "You cannot referr yourself!")