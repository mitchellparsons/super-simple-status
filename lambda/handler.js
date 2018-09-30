const AWS = require('aws-sdk'),
  s3 = new AWS.S3({ apiVersion: '2006-03-01' }),
  S3_BUCKET = process.env.S3_BUCKET

async function saveInS3(data, service) {
	var params = {
		Body: JSON.stringify(data),
		Bucket: S3_BUCKET,
		Key: `status/${service}`,
		ServerSideEncryption: 'AES256'
	};
	return s3.putObject(params).promise();
}

function parseSNSAlarmMessage(message) {
  console.log('SNS Message:', message)
  let data = JSON.parse(message)
  return {
    name: data.AlarmName,
    state: data.NewStateValue
  }
}

async function processEvent(event) {
  try {
    for(let record of event.Records) {
      let alarmData = parseSNSAlarmMessage(record.Sns.Message)
      let status = {
        state: alarmData.state,
        timestamp: (new Date()).toISOString()
      }
      await saveInS3(status, alarmData.name)
    }
  } catch (err) {
    console.log("ERROR: ", err)
  }
}

exports.handle = async (event) => {
  console.log('handling ', event)
  await processEvent(event)
}
