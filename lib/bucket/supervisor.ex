defmodule Server.Bucket.Supervisor do
	use Supervisor

	# A simple module attribute taht stores the supervisor name
	@name Server.Bucket.Supervisor

	def start_link do
		Supervisor.start_link(__MODULE__, :ok, name: @name)
	end

	def start_bucket do
		Supervisor.start_child(@name, [])
	end

	def init(:ok) do
		children = [
			worker(Server.Bucket, [], restart: :temporary)
		]

		supervise(children, strategy: :simple_one_for_one)
	end 
end