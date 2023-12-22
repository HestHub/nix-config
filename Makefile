
darwin:
	nix build .#darwinConfigurations.mbp.system \
		--extra-experimental-features 'nix-command flakes'

	./result/sw/bin/darwin-rebuild switch --impure --flake .#mbp

darwin-debug:
	nix build .#darwinConfigurations.mbp.system --show-trace --verbose \
		--extra-experimental-features 'nix-command flakes'

	./result/sw/bin/darwin-rebuild switch --flake .#mbp --show-trace --verbose

bootstrap:
	curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


setup-ssh:
# 	generate ssh keys for diffrent folders 
#	ssh-keygen -t rsa -b 4096 -C "Email"
#	promt password, return pubkey to clipboard

post-fix:
#	 add fish to available shell if not already present
	if ! grep -q "/etc/profiles/per-user/hest/bin/fish" /etc/shells; then echo "hello"; fi

#	add nix user bin to path if not already present
#	/etc/profiles/per-user/hest/bin  -> /etc/paths

#	copy iterm config to dynamic profiles if not already present
#   .dotfiles/iterm2.json -> /Users/hest/Library/Application Support/iTerm2/DynamicProfiles

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
