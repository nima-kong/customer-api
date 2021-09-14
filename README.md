# APIOps demo
This repository contains customer-api project created with Insomnia and a workflow to build and deploy Kong services, routs and plugins.
## Customer API
You can use insomnia to directly import this project from git repository. After importing the project, You can find the API specification in the Design tab. This is a simple api which returns a list of customers. It also has some ``` x-kong- ``` tags. These metadata will be used by inso CLI to generate the Kong plugins. In this case we used the following metadata to create Mocking plugin.
```
x-kong-plugin-mocking:
  enabled: true
  config:
   api_specification_filename: customer.yaml
```
Another thing it worth noticing is the ``` url ``` in the specification.
```
servers:
  - url: ${UPSTREAM_SERVER_URL}$
    description: Upstream server URL.

```
The value for the ``` url ``` tag is parameterized and will be injected during the deployment time.     

If you want to test the API, you can use the debug tab and call the customer api. Please update the environment to point to the correct end point. In this case, we have deployed this API in a k8s cluster in Azure.
```
{
  "scheme": [
    "http"
  ],
  "base_path": "",
  "host": "kong-proxy.23c9f5ecaad14c5ebbba.australiaeast.aksapp.io"
}
```
In order to create test cases for your api, you can use the Test tab in Insomnia. In this project, we have created a simple test case for HTTP 200 response code.
```
const response1 = await insomnia.send();

expect(response1.status).to.equal(200);

```
We will run this test case as part of our Git Actions workflow to make sure, api deployment was successful.

## GitHub Actions
I have created a simple workflow to build and deploy Kong Services, routes and plugins. This workflow starts with checking out the the code, creating a backup from customer api specification and installing nodejs, deck, inso CLI and dev portal CLI.  
The ```Validate Specification``` job uses inso CLI to do automated linting. If these is a problem with the api specification, it will stop the build process.  

```Prepare URL 4 Portal``` job replaces the  ```url``` with the Kong gateway address. This is because when we publish the api specification to the Dev Portal, it should call the service hosted in Kong not the backend api.  

```Deploy to dev portal``` job uses portal CLI to deploy the api specification to the dev portal. Please note that portal CLI requires a directory with the same workspace name. In this case it's ```customer```.  

Next step is to create declarative configuration using inso CLI and use Deck to deploy it to the Kong gateway.
At the end we use inso CLI to run the test cases we built in Insomnia.    
