# IBM ODM Decision Server in Message-driven Architecture with Apache Kafka
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Introduction

In a message-driven architecture, client applications interact with services that reply to their requests.
The advantages of message-driven architecture are asynchronous communication and the scalability with load balancing.
This type of architecture is based on a broker allowing to subscribe to a topic and publish messages.

This sample shows how to use IBM Operational Decision Manager (ODM) with Apache Kafka, which is a distributed streaming platform allowing the setup of a message driven architecture.

**TODO Architecture DIAGRAM**


In the architecture of the sample, client applications send a loan request and decision services execute the loan request against a ruleset. The trace is then send to the kafka topic.



### Workflow description
The following diagram describes the workflow:


**TODO Architecture DIAGRAM**

1. Client application acts as REST API producer .

2. Decision service implementing ODM acts as a RESTApi Server and executes the payload.

3. After executing the payload against the ruleset, the decision service acts as a Kafka producer and puts the json result in the topic named BAITopic.

4. The client application acts as Kafka consumer and gets the message corresponding to the result of its request.

## Requirements

* Apache Kafka 2.2
* Docker or Kubernetes implementation.
* curl command line.


## Before starting
* Clone the project repository from github:

  ```$ git clone https://github.com/ODMDev/odm-ondocker.git```

## Starting Kafka infrastructure

Starting the Kafka servers:

* Make sure that you have Kafka installed, and start Kafka by launching zookeeper and Kafka-server.


## Configure your Kafka Topics for ODM
### Edit the [contrib/kafka-emission/plugin.properties](contrib/kafka-emission/plugin.properties) file.

  This file must contain the name of the Kafka topic and at least one Kafka bootstrap server.

```
com.ibm.rules.bai.plugin.topic=<kafka_topic_name>                       
com.ibm.rules.bai.plugin.kafka.bootstrap.servers=<KAFKASERVER>:9092
```

Where topic defines the name of the Kafka topic and bootstrap.servers defines the Kafka target servers.

All properties must be prefixed with **com.ibm.rules.bai.plugin**.

All Kafka producer properties, for example, bootstrap.servers must be prefixed with **com.ibm.rules.bai.plugin.kafka**.

Other properties are optional. For a list of possible Kafka producer properties, see Producer Configs.

The connection to Kafka can be configured with or without security.

####    Configure event emission without security.

The following example is a configuration file with a Kafka producer property named retries. The property causes the client to resend any record that fails with a potentially transient error. However, the connection is not secured.
    
```
com.ibm.rules.bai.plugin.topic=<kafka_topic_name>                       
com.ibm.rules.bai.plugin.kafka.bootstrap.servers=<KAFKASERVER>:9092
com.ibm.rules.bai.plugin.kafka.retries=2
```

#### Configure event emission with security.
    To ensure that your connection to the Kafka servers is secure, add a truststore to your Kafka configuration. The following example is a configuration file with a SASL_SSL secured connection.

```
    com.ibm.rules.bai.plugin.topic=<kafka_topic_name>
    com.ibm.rules.bai.plugin.kafka.bootstrap.servers=<KAFKASERVER>:9092
    com.ibm.rules.bai.plugin.kafka.security.protocol=SASL_SSL
    com.ibm.rules.bai.plugin.kafka.ssl.truststore.location=/config/baiemitterconfig/<truststore.jks>
    com.ibm.rules.bai.plugin.kafka.ssl.truststore.password=<truststore_password>
    com.ibm.rules.bai.plugin.kafka.sasl.mechanism=PLAIN
    com.ibm.rules.bai.plugin.kafka.ssl.protocol=TLSv1.2
    com.ibm.rules.bai.plugin.kafka.sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="token" password="<api_key>";
```

    The directory /config/baiemitterconfig/ must be used as a prefix to your certificate name. For example, if your certificate file name is truststore.jks, then the property must be defined as com.ibm.rules.bai.plugin.kafka.ssl.truststore.location=/config/baiemitterconfig/trustore.jks.

    For more information, see [Kafka Security documentation](https://kafka.apache.org/11/documentation.html#security) .



## Starting the ODM Docker image
Use the following command to start the ODM docker image with the Kafka emission enabled :

`$ docker-compose up`

## Running the scenarios

In the scenario, a client application send one payload to a decision services.
The client application is a curl cmd line application that sends a payload with information about the borrower and the loan request, and waits for the approval or rejection of the loan request.
The decision service is an ODM Docker image, which executes the payload against the ODM loan validation sample ruleset and returns a result (approved or rejected) to the client application, then a kafka call is performed to send traces to the Kafka server.

1. Deploy the sample ruleset :

`$ ./deployRuleapp.sh`

```
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<result>
    <resource xsi:type="deploymentReport" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <operation>
            <initialPath>/LoanValidationDS/1.0</initialPath>
            <resultPath>/LoanValidationDS/1.0</resultPath>
            <operationType>ADD</operationType>
        </operation>
        <operation>
            <initialPath>/LoanValidationDS/1.0/loan_validation_production/1.0</initialPath>
            <resultPath>/LoanValidationDS/1.0/loan_validation_production/1.0</resultPath>
            <operationType>ADD</operationType>
            <managedXomGeneratedProperty>reslib://LoanValidationDS_1.0/1.0,</managedXomGeneratedProperty>
        </operation>
        <operation>
            <initialPath>/LoanValidationDS/1.0/loan_validation_with_score_and_grade/1.0</initialPath>
            <resultPath>/LoanValidationDS/1.0/loan_validation_with_score_and_grade/1.0</resultPath>
            <operationType>ADD</operationType>
            <managedXomGeneratedProperty>reslib://LoanValidationDS_1.0/1.0,</managedXomGeneratedProperty>
        </operation>
        <operation>
            <type>URI</type>
            <initialPath>/loan-validation-ds-xom.zip/1.0</initialPath>
            <resultPath>/loan-validation-ds-xom.zip/1.0</resultPath>
            <operationType>ADD</operationType>
        </operation>
        <operation>
            <type>LIB</type>
            <initialPath>/LoanValidationDS_1.0/1.0</initialPath>
            <resultPath>/LoanValidationDS_1.0/1.0</resultPath>
            <operationType>ADD</operationType>
        </operation>
    </resource>
    <succeeded>true</succeeded>
</result>
```

2. Execute the decision service command:

  `$ executeDecision.sh`

```
 Execution seems correct.
```

3. Retrieve the decision trace in Kafka Topic you have configue in the properties file.

You should retrieved your trace in your kafka broker.

## Issues and contributions

To contribute or for any issue please use GitHub Issues tracker.

## References
* [IBM Operational Decision Manager Developer Center](https://developer.ibm.com/odm/)
* [Loan Validation Sample](https://www.ibm.com/support/knowledgecenter/SSQP76_8.10.x/com.ibm.odm.dcenter.tutorials/tutorials_topics/tpc_dc_scenario.html)
* [Apache Kafka](https://kafka.apache.org/)

## License
[Apache 2.0](LICENSE)

[## Notice
© Copyright IBM Corporation 2019.


[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
