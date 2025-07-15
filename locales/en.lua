local Translations = {
    -- Character Selection Menu
    ['char_select_title'] = 'Character Selection',
    ['char_select_subtitle'] = 'Choose your character or create a new one',
    ['char_select_close'] = 'Close',
    ['char_create_new'] = 'Create New Character',
    ['char_create_new_desc'] = 'Create a new character (%s/%s)',
    ['char_limit_reached_title'] = 'Character Limit Reached',
    ['disconnect'] = 'Disconnect',
    ['disconnect_desc'] = 'Leave the server',
    ['char_play'] = '▶️ Play',
    ['char_delete'] = 'Delete Character',
    ['char_info'] = 'ℹ️ Character Info',
    ['char_enter'] = 'Enter Character',
    ['char_enter_desc'] = 'Login with this character',
    ['char_delete_warning_desc'] = '⚠️ Permanently delete this character',
    ['char_back_to_list'] = 'Back to Characters',
    ['char_back_to_list_desc'] = 'Return to character list',
    
    -- Character Info
    ['char_name'] = 'Name: %s',
    ['char_money'] = 'Cash: $%s',
    ['char_bank'] = 'Bank: $%s',
    ['char_job'] = 'Job',
    ['char_level'] = 'Level',
    ['char_cash'] = 'Cash',
    ['char_id'] = 'Character ID',
    ['char_created'] = 'Created',
    ['char_nationality'] = 'Nationality',
    ['char_gender'] = 'Gender',
    ['char_last_played'] = 'Last Played: %s',
    ['char_playtime'] = 'Playtime: %s hours',
    ['unknown'] = 'Unknown',
    
    -- Character Creation
    ['char_create_title'] = 'Create New Character',
    ['char_create_subtitle'] = 'Enter your character details',
    ['char_create_firstname'] = 'First Name',
    ['char_create_lastname'] = 'Last Name',
    ['char_create_nationality'] = 'Nationality',
    ['char_create_gender'] = 'Gender',
    ['char_create_birthdate'] = 'Birth Date',
    ['char_create_confirm'] = 'Create Character',
    ['char_create_cancel'] = 'Cancel',
    ['char_create_firstname_desc'] = 'Enter your character\'s first name',
    ['char_create_lastname_desc'] = 'Enter your character\'s last name',
    ['char_create_birthdate_desc'] = 'Select your character\'s birth date',
    ['char_create_gender_desc'] = 'Select your character\'s gender',
    ['char_create_nationality_desc'] = 'Select your character\'s nationality',
    
    -- Gender Options
    ['gender_male'] = 'Male',
    ['gender_female'] = 'Female',
    
    -- Character Deletion
    ['char_delete_title'] = 'Delete Character',
    ['char_delete_subtitle'] = 'Are you sure you want to delete this character?',
    ['char_delete_warning'] = '⚠️ This action cannot be undone!',
    ['char_delete_confirm'] = 'Yes, Delete',
    ['char_delete_cancel'] = 'Cancel',
    ['char_delete_name'] = 'Character: %s',
    ['char_delete_success_msg'] = 'has been deleted successfully',
    ['char_delete_cancelled'] = 'Deletion Cancelled',
    ['char_delete_cancelled_msg'] = 'Character deletion cancelled',
    ['disconnect_confirm_title'] = 'Disconnect Confirmation',
    ['disconnect_confirm_msg'] = 'Are you sure you want to leave the server?',
    ['disconnect_confirm'] = 'Yes, Disconnect',
    ['char_delete_type_confirm'] = 'Type "DELETE" to confirm',
    ['char_delete_confirm_desc'] = '⚠️ Type DELETE in CAPITAL letters to confirm deletion of **%s**',
    
    -- System Messages
    ['connecting'] = 'Connecting...',
    ['loading_characters'] = 'Loading characters...',
    ['char_created'] = 'Character created successfully!',
    ['char_deleted'] = 'Character deleted successfully!',
    ['char_loaded'] = 'Character loaded successfully!',
    ['welcome_back'] = 'Welcome back, %s!',
    ['char_loading'] = 'Please Wait',
    ['char_loading_desc'] = 'Character is still loading...',
    
    -- Validation Messages
    ['firstname_required'] = 'First name is required',
    ['lastname_required'] = 'Last name is required',
    ['firstname_length'] = 'First name must be between 2-25 characters',
    ['lastname_length'] = 'Last name must be between 2-25 characters',
    ['firstname_format'] = 'First name can only contain letters',
    ['lastname_format'] = 'Last name can only contain letters',
    ['birthdate_invalid'] = 'Invalid birth date format',
    ['char_limit_reached'] = 'Character limit reached (%s/%s)',
    
    -- Error Messages
    ['error_loading_chars'] = 'Error loading characters',
    ['error_creating_char'] = 'Error creating character',
    ['error_deleting_char'] = 'Error deleting character',
    ['error_char_exists'] = 'A character with this name already exists',
    ['error_invalid_data'] = 'Invalid character data provided',
    ['error_database'] = 'Database error occurred',
    
    -- Debug Messages
    ['debug_enabled'] = 'Multicharacter Debug: Enabled',
    ['debug_disabled'] = 'Multicharacter Debug: Disabled',
    ['debug_chars_loaded'] = 'Loaded %s characters',
    ['debug_char_selected'] = 'Character selected: %s (ID: %s)',
    ['debug_char_created'] = 'Character created: %s %s (ID: %s)',
    ['debug_char_deleted'] = 'Character deleted: ID %s',
    ['debug_camera_setup'] = 'Character camera setup at position: %s, %s, %s',
    ['debug_menu_opened'] = 'Character selection menu opened',
    ['debug_menu_closed'] = 'Character selection menu closed',
    
    -- Admin Commands
    ['admin_only'] = 'This command is for administrators only',
    ['debug_toggle_usage'] = 'Usage: /multidebug',
    
    -- Cache Management
    ['cache_cleared'] = 'Done!',
    ['restart_clean'] = 'Clean restart completed',
    ['logout_forced'] = 'All players have been logged out for maintenance',
    ['restart_notification'] = 'Server Restart',
    ['restart_redirect_msg'] = 'Redirecting you to character selection...',
    ['multi_cache_success'] = 'QR-Multicharacter cache cleared successfully',
}

return Translations
