<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('photo')
                ->after('name')
                ->nullable();

            $table->uuid('uuid')
                ->after('id')
                ->nullable(false);
        });

        Schema::table('users', function (Blueprint $table) {
            $table->renameIndex('users_email_unique', 'idx_unique_email');
            $table->index('created_at', 'idx_data_cadastro');
            $table->index('uuid', 'idx_uuid');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->renameIndex('idx_unique_email', 'users_email_unique');
            $table->dropIndex('idx_data_cadastro');
            $table->dropIndex('idx_uuid');
        });

        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn('photo');
            $table->dropColumn('uuid');
        });
    }
};
