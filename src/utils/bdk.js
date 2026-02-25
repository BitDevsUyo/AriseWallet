import { Descriptor, DescriptorSecretKey, Wallet, Mnemonic, Blockchain, DatabaseConfig } from "bdk-rn";
import { WordCount, Network, KeychainKind } from "bdk-rn/lib/lib/enums";

export const generateNewMnemonics = async () => {
    try {
        const mnemonic = await new Mnemonic().create(WordCount.WORDS12);
        const mnemonicStr = mnemonic.asString();
        return mnemonicStr;
        console.log("Mnemonic:", mnemonicStr);
    } catch (e) {
        console.log(`Error generating mnemonic: ${e}`);
    }
}

export const buildAndSyncWallets = async (mnemonicStr) => {
    try {
        console.log("Starting wallet build...");
        const mnemonic = await new Mnemonic().fromString(mnemonicStr);

        const descriptorSecretKey = await new DescriptorSecretKey().create(
            Network.Testnet,
            mnemonic
        );

        const secretKeyString = await descriptorSecretKey.asString();
        console.log("Secret Key XPRV:", secretKeyString);

        //Create external and internal descriptor for BIP44/49/84/86
        const createParts = async (bipMethod) => {
            const external = await new Descriptor()[bipMethod](
                descriptorSecretKey,
                KeychainKind.External,
                Network.Testnet
            );
            const internal = await new Descriptor()[bipMethod](
                descriptorSecretKey,
                KeychainKind.Internal,
                Network.Testnet
            );
            return { external, internal };
        };
        console.log("Building 4 Wallet Types...");

        // BUILD ALL 4 DESCRIPTORS
        const d44 = await createParts('newBip44');
        const d49 = await createParts('newBip49');
        const d84 = await createParts('newBip84');
        const d86 = await createParts('newBip86');

        const db = await new DatabaseConfig().memory();

        const w44 = await new Wallet().create(d44.external, d44.internal, Network.Testnet, db);
        const w49 = await new Wallet().create(d49.external, d49.internal, Network.Testnet, db);
        const w84 = await new Wallet().create(d84.external, d84.internal, Network.Testnet, db);
        const w86 = await new Wallet().create(d86.external, d86.internal, Network.Testnet, db);

        //Connect to Electrum Blockchain
        console.log("Connecting to Electrum...");
        const blockchainConfig = {
            url: "ssl://electrum.blockstream.info:60002",
            sock5: null,
            retry: 5,
            timeout: 5,
            stopGap: 500,
            validateDomain: false,
        };
        const blockchain = await new Blockchain().create(blockchainConfig);
        const height = await blockchain.getHeight();
        console.log("BlockChain Height:", height)
        console.log("Blockchain connected.");

        const dbConfig = await new DatabaseConfig().memory();

        console.log("Syncing all wallets...");
        await Promise.all([
            w44.sync(blockchain),
            w49.sync(blockchain),
            w84.sync(blockchain),
            w86.sync(blockchain),
        ]);

        // await wallet.sync(blockchain);
        console.log("Wallet synced.");

        // Log wallet balance
        // const balance = await wallet.getBalance();
        const b44 = (await w44.getBalance()).total;
        const b49 = (await w49.getBalance()).total;
        const b84 = (await w84.getBalance()).total;
        const b86 = (await w86.getBalance()).total;

        const totalBalance = b44 + b49 + b84 + b86;
        console.log(" Wallet Balance:", totalBalance);

        //  Log address
        const addrInfo = await w86.getAddress();
        const receiveAddress = await addrInfo.address.asString();
        console.log("First Receive Address:", receiveAddress);

        return {
            activeWalletInstance: w86,
            totalBalance,
            receiveAddress
        };

    } catch (error){
        console.error("Error building wallets:", error);
        throw error;
    }
};