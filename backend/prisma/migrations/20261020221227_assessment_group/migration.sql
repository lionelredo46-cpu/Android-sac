-- AlterTable
ALTER TABLE "Assessment" ADD COLUMN     "datePublication" TIMESTAMP(3),
ADD COLUMN     "groupId" TEXT;

-- AddForeignKey
ALTER TABLE "Assessment" ADD CONSTRAINT "Assessment_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "Group"("id") ON DELETE SET NULL ON UPDATE CASCADE;
