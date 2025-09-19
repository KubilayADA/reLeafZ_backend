/*
  Warnings:

  - You are about to drop the column `address` on the `Doctor` table. All the data in the column will be lost.
  - You are about to drop the column `email` on the `Doctor` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `Doctor` table. All the data in the column will be lost.
  - You are about to drop the column `phone` on the `Doctor` table. All the data in the column will be lost.
  - You are about to drop the column `location` on the `Pharmacy` table. All the data in the column will be lost.
  - The primary key for the `TreatmentRequest` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `city` on the `TreatmentRequest` table. All the data in the column will be lost.
  - You are about to drop the column `email` on the `TreatmentRequest` table. All the data in the column will be lost.
  - You are about to drop the column `fullName` on the `TreatmentRequest` table. All the data in the column will be lost.
  - You are about to drop the column `phone` on the `TreatmentRequest` table. All the data in the column will be lost.
  - The `id` column on the `TreatmentRequest` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - A unique constraint covering the columns `[userId]` on the table `Doctor` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[userId]` on the table `Pharmacy` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `userId` to the `Doctor` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userId` to the `Pharmacy` table without a default value. This is not possible if the table is not empty.
  - Added the required column `zip` to the `Pharmacy` table without a default value. This is not possible if the table is not empty.
  - Added the required column `patientId` to the `TreatmentRequest` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "public"."Role" AS ENUM ('PATIENT', 'DOCTOR', 'PHARMACY', 'ADMIN');

-- CreateEnum
CREATE TYPE "public"."Form" AS ENUM ('FLOWER', 'OIL', 'EXTRACT', 'CAPSULE', 'SPRAY');

-- DropIndex
DROP INDEX "public"."Doctor_email_key";

-- Drop old columns from Doctor
ALTER TABLE "public"."Doctor" DROP COLUMN "address";
ALTER TABLE "public"."Doctor" DROP COLUMN "email";
ALTER TABLE "public"."Doctor" DROP COLUMN "name";
ALTER TABLE "public"."Doctor" DROP COLUMN "phone";

-- Add userId column to Doctor
ALTER TABLE "public"."Doctor" ADD COLUMN "userId" INTEGER NOT NULL DEFAULT 1;

-- Drop old column from Pharmacy
ALTER TABLE "public"."Pharmacy" DROP COLUMN "location";

-- Add new columns to Pharmacy
ALTER TABLE "public"."Pharmacy" ADD COLUMN "userId" INTEGER NOT NULL DEFAULT 1;
ALTER TABLE "public"."Pharmacy" ADD COLUMN "zip" TEXT NOT NULL DEFAULT '10115';

-- Update TreatmentRequest table
ALTER TABLE "public"."TreatmentRequest" DROP CONSTRAINT "TreatmentRequest_pkey";
ALTER TABLE "public"."TreatmentRequest" DROP COLUMN "city";
ALTER TABLE "public"."TreatmentRequest" DROP COLUMN "email";
ALTER TABLE "public"."TreatmentRequest" DROP COLUMN "fullName";
ALTER TABLE "public"."TreatmentRequest" DROP COLUMN "phone";
ALTER TABLE "public"."TreatmentRequest" ADD COLUMN "doctorId" INTEGER;
ALTER TABLE "public"."TreatmentRequest" ADD COLUMN "patientId" INTEGER NOT NULL DEFAULT 1;
ALTER TABLE "public"."TreatmentRequest" DROP COLUMN "id";
ALTER TABLE "public"."TreatmentRequest" ADD COLUMN "id" SERIAL NOT NULL;
ALTER TABLE "public"."TreatmentRequest" ADD CONSTRAINT "TreatmentRequest_pkey" PRIMARY KEY ("id");

-- CreateTable
CREATE TABLE "public"."User" (
    "id" SERIAL NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "role" "public"."Role" NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Patient" (
    "id" SERIAL NOT NULL,
    "userId" INTEGER NOT NULL,
    "zip" TEXT NOT NULL,

    CONSTRAINT "Patient_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Prescription" (
    "id" SERIAL NOT NULL,
    "patientId" INTEGER NOT NULL,
    "doctorId" INTEGER NOT NULL,
    "pharmacyId" INTEGER NOT NULL,
    "orderId" INTEGER,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Prescription_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Product" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "form" "public"."Form" NOT NULL,
    "thcPercent" DOUBLE PRECISION NOT NULL,
    "cbdPercent" DOUBLE PRECISION NOT NULL,
    "price" DOUBLE PRECISION NOT NULL,
    "unit" TEXT NOT NULL,
    "stock" INTEGER NOT NULL,
    "pharmacyId" INTEGER NOT NULL,

    CONSTRAINT "Product_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."Order" (
    "id" SERIAL NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."OrderItem" (
    "id" SERIAL NOT NULL,
    "orderId" INTEGER NOT NULL,
    "productId" INTEGER NOT NULL,
    "quantity" INTEGER NOT NULL,

    CONSTRAINT "OrderItem_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_email_key" ON "public"."User"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Patient_userId_key" ON "public"."Patient"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Prescription_orderId_key" ON "public"."Prescription"("orderId");

-- CreateIndex
CREATE UNIQUE INDEX "Doctor_userId_key" ON "public"."Doctor"("userId");

-- CreateIndex
CREATE UNIQUE INDEX "Pharmacy_userId_key" ON "public"."Pharmacy"("userId");

-- AddForeignKey
ALTER TABLE "public"."Patient" ADD CONSTRAINT "Patient_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Doctor" ADD CONSTRAINT "Doctor_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Pharmacy" ADD CONSTRAINT "Pharmacy_userId_fkey" FOREIGN KEY ("userId") REFERENCES "public"."User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TreatmentRequest" ADD CONSTRAINT "TreatmentRequest_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "public"."Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."TreatmentRequest" ADD CONSTRAINT "TreatmentRequest_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "public"."Doctor"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Prescription" ADD CONSTRAINT "Prescription_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES "public"."Patient"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Prescription" ADD CONSTRAINT "Prescription_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES "public"."Doctor"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Prescription" ADD CONSTRAINT "Prescription_pharmacyId_fkey" FOREIGN KEY ("pharmacyId") REFERENCES "public"."Pharmacy"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Prescription" ADD CONSTRAINT "Prescription_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "public"."Order"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."Product" ADD CONSTRAINT "Product_pharmacyId_fkey" FOREIGN KEY ("pharmacyId") REFERENCES "public"."Pharmacy"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."OrderItem" ADD CONSTRAINT "OrderItem_orderId_fkey" FOREIGN KEY ("orderId") REFERENCES "public"."Order"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."OrderItem" ADD CONSTRAINT "OrderItem_productId_fkey" FOREIGN KEY ("productId") REFERENCES "public"."Product"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
