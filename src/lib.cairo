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

    #[abi(embed_v0)]
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
#[cfg(test)]
mod tests {
    use super::Wallet;
    use super::IWallet;
    use starknet::ContractAddress;
    use starknet::testing::set_caller_address;
    use core::num::traits::Zero;

    #[test]
    #[available_gas(2000000)]
    fn test_get_wallet_address() {
        // Deploy contract
        let contract = Wallet::contract_state_for_testing();
        
        // Set up test caller address
        let test_address: ContractAddress = starknet::contract_address_const::<1>();
        set_caller_address(test_address);

        // Test get_wallet_address returns correct address
        let result = IWallet::get_wallet_address(@contract);
        assert(result == test_address, 'Wrong wallet address');
    }

    #[test]
    #[available_gas(2000000)]
    fn test_prepare_for_transaction() {
        // Deploy contract
        let contract = Wallet::contract_state_for_testing();
        
        // Set up test caller address
        let test_address: ContractAddress = starknet::contract_address_const::<1>();
        set_caller_address(test_address);

        // Test prepare_for_transaction returns true for valid address
        let result = IWallet::prepare_for_transaction(@contract);
        assert(result == true, 'Should return true');
    }

    #[test]
    #[available_gas(2000000)]
    #[should_panic(expected: (404, ))]
    fn test_prepare_for_transaction_zero_address() {
        // Deploy contract
        let contract = Wallet::contract_state_for_testing();
        
        // Set zero address as caller
        let zero_address: ContractAddress = starknet::contract_address_const::<0>();
        set_caller_address(zero_address);

        // Should panic with error 404
        IWallet::prepare_for_transaction(@contract);
    }
}
