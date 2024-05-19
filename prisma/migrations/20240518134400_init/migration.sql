-- CreateTable
CREATE TABLE "Payment" (
    "id" SERIAL NOT NULL,
    "transaction_amount" DOUBLE PRECISION NOT NULL,
    "description" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "identificationType" TEXT NOT NULL,
    "number" TEXT NOT NULL,

    CONSTRAINT "Payment_pkey" PRIMARY KEY ("id")
);
