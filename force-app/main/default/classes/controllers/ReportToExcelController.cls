global with sharing class ReportToExcelController{
	global String excelTitle {get;set;}
	global String xmlheader {get;set;}
	global List<Row> rows {get;set;}

	global ReportToExcelController(){
		Map<String, String> valueByParameter = ApexPages.currentPage().getParameters();
		String reportId = valueByParameter.get('reportId');
		String fileName = valueByParameter.get('fileName');
		excelTitle = 'application/vnd.ms-excel'+(String.isNotBlank(fileName) ? '#'+fileName+'.xls' : '');
		xmlheader = Constants.XML_HEADER;
		rows = new List<Row>();
		Reports.ReportDescribeResult describe = Reports.ReportManager.describeReport(reportId);
		initTableHeader(describe);
		initTableRows(reportId, valueByParameter, describe);
	}

	private void initTableHeader(Reports.ReportDescribeResult describe){
		Reports.ReportExtendedMetadata reportExtMd = describe.getReportExtendedMetadata();
		Row header = new Row();
		for(Reports.DetailColumn column : reportExtMd.getDetailColumnInfo().values())
			header.cells.add(column.getLabel());
		rows.add(header);
	}

	private void initTableRows(String reportId, Map<String, String> valueByParameter, Reports.ReportDescribeResult describe){
		Reports.ReportMetadata reportMd = describe.getReportMetadata();
		for(String parameter : valueByParameter.keySet()){
			if(parameter.contains('fv')){
				Integer index = Integer.valueOf(parameter.replace('fv', ''));
				String value = valueByParameter.get(parameter);
				reportMd.getReportFilters()[index].setValue(value);
			}
		}
		Reports.ReportResults results = Reports.ReportManager.runReport(reportId, reportMd, true);
		Reports.ReportFactWithDetails factDetails = (Reports.ReportFactWithDetails)results.getFactMap().get('T!T');
		for(Reports.ReportDetailRow detailRow : factDetails.getRows()){
			Row row = new Row();
			for(Reports.ReportDataCell cell : detailRow.getDataCells())
				row.cells.add(cell.getLabel());
			rows.add(row);
		}
	}

	global class Row{
		global List<String> cells {get;set;}

		global Row(){
			cells = new List<String>();
		}
	}
}