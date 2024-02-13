include .env
export

darwin:
	nix build .#darwinConfigurations.mbp.system \
		--extra-experimental-features 'nix-command flakes'

	./result/sw/bin/darwin-rebuild switch --impure --flake .#mbp

bootstrap:
# 	install nix
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
# 	install homebrew
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

ssh_keys:
#	Generate ssh keys
	ssh-keygen -t ed25519 -C "$$M_MAIL" -f ~/.ssh/$$M_ID -N $$PASSWORD
	ssh-keygen -t rsa -C "$$G_MAIL" -f ~/.ssh/$$G_ID -N $$PASSWORD
	ssh-keygen -t ed25519 -C "$$C_MAIL" -f ~/.ssh/$$C_ID -N $$PASSWORD
# 	add keys to ssh-agent
	ssh-add --apple-use-keychain ~/.ssh/$$M_ID
	ssh-add --apple-use-keychain ~/.ssh/$$C_ID
	ssh-add --apple-use-keychain ~/.ssh/$$G_ID

post-fix:
#	 add fish to available shell if not already present
	if ! grep -qF "/etc/profiles/per-user/${M_USER}/bin/fish" /etc/shells; \
		then echo "/etc/profiles/per-user/${M_USER}/bin/fish" | sudo tee -a /etc/shells; fi

#	add nix user bin to path if not already present
	if ! grep -qF "/etc/profiles/per-user/${M_USER}/bin" /etc/paths; \
		then echo "/etc/profiles/per-user/${M_USER}/bin" | sudo tee -a /etc/paths; fi

#	copy iterm config to dynamic profiles if not already present
	if [[ ! -f /Users/${M_USER}/Library/Application\ Support/iTerm2/DynamicProfiles/iterm2.json ]];\
		then cp ./dotfiles/iterm2.json /Users/${M_USER}/Library/Application\ Support/iTerm2/DynamicProfiles/; fi

#   rtx add plugins and install them
	rtx plugin add dotnet
	rtx plugin add azure-cli
	rtx install

# 	enable shims support for IDEA IDEs ( they support asdf but not mise nativly)
	ln -s ~/.local/share/mise ~/.asdf
#	add complettion for mise in fish
	mise completion fish > ~/.config/fish/completions/mise.fish

update:
	nix flake update

history:
	nix profile history --profile /nix/var/nix/profiles/system

gc:
	sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

	sudo nix store gc --debug

fmt:
	nix fmt

.PHONY: clean  
clean:  
	rm -rf result
