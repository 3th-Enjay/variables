use starknet::ContractAddress;
use starknet::get_caller_address;

#[starknet::interface]
trait IWallet<TContractState> {
    fn get_wallet_address(self: @TContractState) -> ContractAddress;
    fn prepare_for_transaction(self: @TContractState) -> bool;
}

#[starknet::contract]
mod Wallet {
    use core::num::traits::Zero;
use super::ContractAddress;
    use super::get_caller_address;

    #[storage]
    struct Storage {
        wallet_address: ContractAddress,
    }

    #[external(v0)]
    impl WalletImpl of super::IWallet<ContractState> {
        fn get_wallet_address(self: @ContractState) -> ContractAddress {
            // Get the caller's address
            let caller = get_caller_address();
            caller
        }

        fn prepare_for_transaction(self: @ContractState) -> bool {
            // Verify the wallet exists and is ready
            let caller = get_caller_address();
            assert(!caller.is_zero(), 404);
            
            true // Return true if wallet is ready to receive
        }
    }
}