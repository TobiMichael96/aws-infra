import { SecretsManagerClient, GetSecretValueCommand } from "@aws-sdk/client-secrets-manager";


export const handler = async (event, context) => {
    console.log("EVENT: \n" + JSON.stringify(event, null, 2));

    const region_input = process.env.region //"eu-central-1";
    const secret_id_input = process.env.secret_id;

    const client = new SecretsManagerClient({ "region": region_input});

    const get_input = {
        "SecretId": secret_id_input 
    };

    const get_command = new GetSecretValueCommand(get_input);

    // async/await.
    try {
        const data = await client.send(get_command);
        console.log(data);
    } catch (error) {
        console.log(error);
    }
};