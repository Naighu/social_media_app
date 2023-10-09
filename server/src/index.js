import express from 'express';
import graphqlHTTP from 'express-graphql';
import schema from './schema/schema.js';
import './mongodb.js'
import path from 'path';
import bodyParser from 'body-parser';
const app = express();

let dirname = path.resolve() + '/uploaded_assets/'

app.use(bodyParser.json({limit: '50mb'}));
app.use('/uploaded_assets',express.static(dirname))

app.use('/graphql', graphqlHTTP.graphqlHTTP({
    schema,
    graphiql: true
}));

app.listen(4000, () => {
    console.log('now listening for requests on port 4000');
});