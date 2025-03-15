.PHONY : commit upload repo install_devops install_brownie deploy clear

install_devops :; forge install cyfrin/foundry-devops@0.2.2 --no-commit

install_brownie :; forge install smartcontractkit/chainlink-brownie-contracts --no-commit

repo:
	@echo "Enter repo name: "; \
	read msg; \
	gh repo create "$$msg" --public --source=. --remote=origin

upload:
	@git push -u origin main

commit:
	@echo "Enter commit message: "; \
	read msg; \
	git add .; \
	git commit -m "$$msg"

deploy:
	forge build
	forge script script/MyLearning.s.sol:DepoyAndTestInterface --rpc-url http://127.0.0.1:8545 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80 --broadcast
# Debug Techniques
# 1. forge clean

clear:
	@forge clean
#General Debugs
# 1. missing seperator
# => indentation OR :;
#
#
#
#
#
#
#
#
#

#################################
# General copy-paste things
# import {Script} from "lib/forge-std/src/Script.sol";
# import {Test, console} from "lib/forge-std/src/Test.sol";
