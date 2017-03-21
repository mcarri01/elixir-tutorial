defmodule Server.BucketTest do
	use ExUnit.Case, async: true

	setup do
		{:ok, bucket} = Server.Bucket.start_link
		{:ok, bucket: bucket}
	end

	test "stores values by key", %{bucket: bucket} do
		assert Server.Bucket.get(bucket, "milk") == nil

		Server.Bucket.put(bucket, "milk", 3)
		assert Server.Bucket.get(bucket, "milk") == 3
	end

	test "delets values by key", %{bucket: bucket} do
		Server.Bucket.put(bucket, "test", 4)
		assert Server.Bucket.get(bucket, "test") == 4

		Server.Bucket.delete(bucket, "test")
		assert Server.Bucket.get(bucket, "test") == nil
	end
		
end