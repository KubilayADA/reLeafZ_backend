/*
  Warnings:

  - Added the required column `patientName` to the `Prescription` table without a default value. This is not possible if the table is not empty.
  - Added the required column `patientZip` to the `Prescription` table without a default value. This is not possible if the table is not empty.
  - Added the required column `city` to the `TreatmentRequest` table without a default value. This is not possible if the table is not empty.
  - Added the required column `email` to the `TreatmentRequest` table without a default value. This is not possible if the table is not empty.
  - Added the required column `fullName` to the `TreatmentRequest` table without a default value. This is not possible if the table is not empty.
  - Added the required column `phone` to the `TreatmentRequest` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "public"."Doctor" ALTER COLUMN "userId" DROP DEFAULT;

-- AlterTable
ALTER TABLE "public"."Pharmacy" ALTER COLUMN "userId" DROP DEFAULT,
ALTER COLUMN "zip" DROP DEFAULT;

-- AlterTable
ALTER TABLE "public"."Prescription" ADD COLUMN     "patientName" TEXT NOT NULL,
ADD COLUMN     "patientZip" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "public"."TreatmentRequest" ADD COLUMN     "city" TEXT NOT NULL,
ADD COLUMN     "email" TEXT NOT NULL,
ADD COLUMN     "fullName" TEXT NOT NULL,
ADD COLUMN     "phone" TEXT NOT NULL,
ALTER COLUMN "patientId" DROP DEFAULT;
