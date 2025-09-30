global without sharing class FileRecordIdUpdateScheduler implements Schedulable{

	private FileRecordIdUpdateScheduler(){}

	global static FileRecordIdUpdateScheduler newInstance(){
		return new FileRecordIdUpdateScheduler();
	}

	global void execute(SchedulableContext sc){
		DatabaseService.executeBatch(FileRecordIdUpdateJob.instanceForNewRecords());
	}
}