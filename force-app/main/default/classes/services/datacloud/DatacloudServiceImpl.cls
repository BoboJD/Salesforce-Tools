global inherited sharing class DatacloudServiceImpl implements IDatacloudService{

	@SuppressWarnings('PMD.CognitiveComplexity')
	global List<SObject> findDuplicates(SObject record){
		List<SObject> duplicates = new List<SObject>();
		for(Datacloud.FindDuplicatesResult findDuplicatesResult : Datacloud.FindDuplicates.findDuplicates(new List<SObject>{record})){
			for(Datacloud.DuplicateResult duplicateResult : findDuplicatesResult.getDuplicateResults()){
				for(Datacloud.MatchResult matchResult : duplicateResult.getMatchResults()){
					for(Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()){
						duplicates.add(matchRecord.getRecord());
					}
				}
			}
		}
		return duplicates;
	}
}