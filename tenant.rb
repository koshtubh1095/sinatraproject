class Tenant < RequestLogAnalyzer::FileFormat::Rails
line_definition :current_tenant do |line|
      line.header = true
      line.regexp = /\d* ?\w+ \/.* total=(\d+[\.\d+]*) views=\d+[\.\d+]* database=\d+[\.\d+]* tenant=(\w+)/
      line.capture(:tenant_duration).as(:duration, unit: :msec)
      line.capture(:tenant_name)
    end
    report(:append) do |analyze|
    analyze.frequency :tenant_name, :title => "Requests by Tenant"
      analyze.duration :tenant_duration, :title => "Duration of tenant requests", :category => :tenant_name
  end
end