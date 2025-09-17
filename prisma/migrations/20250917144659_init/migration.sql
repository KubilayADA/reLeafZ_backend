/*
  Warnings:

  - The primary key for the `Doctor` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `createdAt` on the `Doctor` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `Doctor` table. All the data in the column will be lost.
  - The `id` column on the `Doctor` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - The primary key for the `Pharmacy` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `createdAt` on the `Pharmacy` table. All the data in the column will be lost.
  - You are about to drop the column `updatedAt` on the `Pharmacy` table. All the data in the column will be lost.
  - The `id` column on the `Pharmacy` table would be dropped and recreated. This will lead to data loss if there is data in the column.
  - A unique constraint covering the columns `[email]` on the table `Doctor` will be added. If there are existing duplicate values, this will fail.

*/
-- AlterTable
ALTER TABLE "public"."Doctor" DROP CONSTRAINT "Doctor_pkey",
DROP COLUMN "createdAt",
DROP COLUMN "updatedAt",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "Doctor_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "public"."Pharmacy" DROP CONSTRAINT "Pharmacy_pkey",
DROP COLUMN "createdAt",
DROP COLUMN "updatedAt",
DROP COLUMN "id",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "Pharmacy_pkey" PRIMARY KEY ("id");

-- CreateIndex
CREATE UNIQUE INDEX "Doctor_email_key" ON "public"."Doctor"("email");
