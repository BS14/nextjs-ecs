import Image from "next/image";

export default function Home() {
  return (
    <main className="bg-gray-100 min-h-screen flex flex-col items-center justify-center p-8">
      {/* Header Section */}
      <div className="text-center">
        <h1 className="text-5xl font-bold text-blue-600 mb-4">
          Welcome to the World of Containers
        </h1>
        <p className="text-lg text-gray-700">
          Explore the tools and technologies that power modern applications.
        </p>
      </div>

      {/* Centered Image Grid */}
      <div className="grid grid-cols-1 sm:grid-cols-2 gap-10 mt-10 place-items-center">
        {/* Docker */}
        <div className="flex flex-col items-center">
          <Image
            src="/docker.svg"
            alt="Docker"
            width={150}
            height={150}
            className="rounded-lg"
          />
          <p className="mt-4 text-gray-800 font-semibold">Docker</p>
        </div>

        {/* Kubernetes */}
        <div className="flex flex-col items-center">
          <Image
            src="/aws-ecs.svg"
            alt="Elastic Container Service"
            width={150}
            height={150}
            className="rounded-lg"
          />
          <p className="mt-4 text-gray-800 font-semibold">Elastic Container Service</p>
        </div>
      </div>
    </main>
  );
}
