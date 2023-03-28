import { SecretsManagerClient, GetSecretValueCommand } from "@aws-sdk/client-secrets-manager";
import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const Imap = require('imap'), inspect = require('util').inspect;

export const handler = async (event, context) => {
    console.log("EVENT: \n" + JSON.stringify(event, null, 2));

    const region_input = process.env.region;
    const secret_id_input = process.env.secret_id;

    const client = new SecretsManagerClient({ "region": region_input});

    const get_input = {
        "SecretId": secret_id_input 
    };

    const get_command = new GetSecretValueCommand(get_input);

    try {
        var data = await client.send(get_command);
        data = JSON.parse(data.SecretString);
        const imap = new Imap({
            user: data.name,
            password: data.password,
            host: data.host,
            port: data.port,
            tls: data.tls
          });

        imap.once('ready', () => {
            imap.openBox('INBOX', false, () => {
                imap.search(['UNSEEN', ['SINCE', new Date()]], (err, results) => {
                    const f = imap.fetch(results, {bodies: ''});
                    f.on('message', msg => {msg.on('body', stream => {
                        simpleParser(stream, async (err, parsed) => {
                            console.log(parsed);
                        });
                    });
                    msg.once('attributes', attrs => {
                        const {uid} = attrs;imap.addFlags(uid, ['\\Seen'], () => {
                            console.log('Marked as read!');
                        });
                    }); 
                });
                f.once('error', ex => {return Promise.reject(ex);
            });
        
            f.once('end', () => {
                console.log('Done fetching all messages!');
                imap.end(); 
            });
        });
        });
        });
    } catch (error) {
        console.log(error);
    }
};