<?php

namespace Database\Seeders;

use App\Models\Raca;
use Illuminate\Database\Seeder;

class RacaSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        Raca::create(['nome' => 'Labrador Retriever', 'especie_id' => 1]);
        Raca::create(['nome' => 'Buldogue Francês', 'especie_id' => 1]);
        Raca::create(['nome' => 'Pastor Alemão', 'especie_id' => 1]);
        Raca::create(['nome' => 'Beagle', 'especie_id' => 1]);
        Raca::create(['nome' => 'Poodle', 'especie_id' => 1]);
        Raca::create(['nome' => 'Golden Retriever', 'especie_id' => 1]);
        Raca::create(['nome' => 'Rottweiler', 'especie_id' => 1]);
        Raca::create(['nome' => 'Yorkshire Terrier', 'especie_id' => 1]);
        Raca::create(['nome' => 'Boxer', 'especie_id' => 1]);
        Raca::create(['nome' => 'Dachshund', 'especie_id' => 1]);

        Raca::create(['nome' => 'Siamês', 'especie_id' => 2]);
        Raca::create(['nome' => 'Maine Coon', 'especie_id' => 2]);
        Raca::create(['nome' => 'Persa', 'especie_id' => 2]);
        Raca::create(['nome' => 'Sphynx', 'especie_id' => 2]);
        Raca::create(['nome' => 'Bengal', 'especie_id' => 2]);
        Raca::create(['nome' => 'Ragdoll', 'especie_id' => 2]);
        Raca::create(['nome' => 'British Shorthair', 'especie_id' => 2]);
        Raca::create(['nome' => 'Abissínio', 'especie_id' => 2]);
        Raca::create(['nome' => 'Scottish Fold', 'especie_id' => 2]);
        Raca::create(['nome' => 'Burmese', 'especie_id' => 2]);
    }
}
