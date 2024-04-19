# Remove existing task configuration if it exists
rm -rf ~/.taskrc
rm -rf ~/.task
rm -rf ~/.config/task

# Link configuration files and directories
ln -sfv ~/dotfiles/taskwarrior/task/ ~/.config

# Remove all files in the .vit directory if it exists, then link new configurations
rm -rf ~/.vit
mkdir ~/.vit
ln -sfv ~/dotfiles/taskwarrior/vit/* ~/.vit/

