require File.dirname(__FILE__) + '/helper'

describe Scoop::Parser do

  it 'should parse a ListAllMyBucketsResult' do

    response = <<-RES
      <?xml version="1.0" encoding="UTF-8"?>
      <ListAllMyBucketsResult xmlns="http://doc.s3.amazonaws.com/2006-03-01">
        <Owner>
          <ID>bcaf1ffd86f461ca5fb16fd081034f</ID>
          <DisplayName>webfile</DisplayName>
        </Owner>
        <Buckets>
          <Bucket>
            <Name>quotes;/Name>
            <CreationDate>2006-02-03T16:45:09.000Z</CreationDate>
          </Bucket>
          <Bucket>
            <Name>samples</Name>
            <CreationDate>2006-02-03T16:41:58.000Z</CreationDate>
          </Bucket>
        </Buckets>
      </ListAllMyBucketsResult>
    RES

    parsed = Scoop::Parser.parse(response)
    parsed.size.must_equal 2
    parsed[0].must_be_instance_of Scoop::Bucket
  end

  it 'should parse a ListBucketResult' do

    response = <<-RES
      <?xml version="1.0" encoding="UTF-8"?>
      <ListBucketResult xmlns="http://s3.amazonaws.com/doc/2006-03-01">
        <Name>quotes</Name>
        <Prefix>N</Prefix>
        <Marker>Ned</Marker>
        <MaxKeys>40</MaxKeys>
        <IsTruncated>false</IsTruncated>
        <Contents>
          <Key>Nelson</Key>
          <LastModified>2006-01-01T12:00:00.000Z</LastModified>
          <ETag>&quot;828ef3fdfa96f00ad9f27c383fc9ac7f&quot;</ETag>
          <Size>5</Size>
          <StorageClass>STANDARD</StorageClass>
          <Owner>
            <ID>bcaf161ca5fb16fd081034f</ID>
            <DisplayName>webfile</DisplayName>
           </Owner>
        </Contents>
        <Contents>
          <Key>Neo</Key>
          <LastModified>2006-01-01T12:00:00.000Z</LastModified>
          <ETag>&quot;828ef3fdfa96f00ad9f27c383fc9ac7f&quot;</ETag>
          <Size>4</Size>
          <StorageClass>STANDARD</StorageClass>
           <Owner>
            <ID>bcaf1ffd86a5fb16fd081034f</ID>
            <DisplayName>webfile</DisplayName>
          </Owner>
       </Contents>
      </ListBucketResult>
    RES

    parsed = Scoop::Parser.parse(response)
    parsed.size.must_equal 2
    parsed[0].must_be_instance_of Scoop::S3Object

  end

  it 'should parse a WebsiteConfiguration' do
    response = <<-RES
      <?xml version="1.0" encoding="UTF-8"?>
      <WebsiteConfiguration xmlns="http://s3.amazonaws.com/doc/2006-03-01/">
        <IndexDocument>
          <Suffix>index.html</Suffix>
        </IndexDocument>
        <ErrorDocument>
          <Key>404.html</Key>
        </ErrorDocument>
      </WebsiteConfiguration>
    RES

    parsed = Scoop::Parser.parse(response)
    parsed[:index_document].must_equal 'index.html'
    parsed[:error_document].must_equal '404.html'
  end
end

