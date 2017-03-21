defmodule Server.RegistryTest do
	use ExUnit.Case, async: true

	setup context do
		{:ok, _} = Server.Registry.start_link(context.test)
		{:ok, registry: context.test}
	end

	test "spawns buckets", %{registry: registry} do
		assert Server.Registry.lookup(registry, "shopping") == :error

		Server.Registry.create(registry, "shopping")
		assert {:ok, bucket} = Server.Registry.lookup(registry, "shopping")

		Server.Bucket.put(bucket, "milk", 1)
		assert Server.Bucket.get(bucket, "milk") == 1
	end

	test "removes buckets on exit", %{registry: registry} do
		Server.Registry.create(registry, "shopping")
		{:ok, bucket} = Server.Registry.lookup(registry, "shopping")
		Agent.stop(bucket)

		_ = Server.Registry.create(registry, "bogus")
		assert Server.Registry.lookup(registry, "shopping") == :error
	end

	test "removes bucket on crash", %{registry: registry} do
		Server.Registry.create(registry, "shopping")
		{:ok, bucket} = Server.Registry.lookup(registry, "shopping")

		# Stop the bucket with non-normal reason
		ref = Process.monitor(bucket)
		Process.exit(bucket, :shutdown)

		# Wait until the bucket is dead
		assert_receive {:DOWN, ^ref, _, _, _}
		_ = Server.Registry.create(registry, "bogus")
		assert Server.Registry.lookup(registry, "shopping") == :error
	end
end