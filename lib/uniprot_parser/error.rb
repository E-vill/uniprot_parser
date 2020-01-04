module UniprotParser

  class UniprotServerUnreachable < StandardError
  end

  class MalformedIdError< StandardError
  end

  class RequestedProteomDoesNotExists < StandardError
  end

  class RequestedProteinDoesNotExists < StandardError
  end

end