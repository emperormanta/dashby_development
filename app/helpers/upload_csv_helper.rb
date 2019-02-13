module UploadCsvHelper
    def upload_csv(file)
        uploader = CsvUploader.new
        uploader.store!(file)
    end
end
