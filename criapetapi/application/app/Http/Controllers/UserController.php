<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\UserPhoto;
use App\Services\ErrorMessageService;
use Exception;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\File;
use Illuminate\Validation\ValidationException;

class UserController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $users = User::with('photo')->get()->map(function (User $user){
            if (empty($user->apelido)) {
                $user->apelido = explode(' ', $user->name)[0];
            }
            return $user;
        });

        return new JsonResponse($users);
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        try {
            $request->validate([
                'name' =>'required|string|min:3|max:250',
                'email' =>'required|email|max:250|unique:users',
                'apelido' =>'string|min:3|max:45',
                'password' =>'required|string|min:8',
                'photo' => [
                    File::types(['jpg', 'jpeg', 'png', 'gif'])->max(12 * 1024),
                ],
            ]);

            $dados = [
                'name' => $request->name,
                'email' => $request->email,
                'password' => $request->password,
            ];

            if ($request->hasFile('photo')) {
                $file = $request->file('photo');
                $originalFileName = $file->getClientOriginalName();

                $extension      = pathinfo($originalFileName, PATHINFO_EXTENSION);
                $basename       = bin2hex(random_bytes(8));
                $newFilename    = date('U'). sprintf('%s.%0.8s', $basename, $extension);
                $directory      = $this->getPathPhotoUpload('user_photo');

                $file->storeAs($directory, $newFilename, 'private');

                $dados['photo'] = $directory . DIRECTORY_SEPARATOR . $newFilename;
            }

            $user = User::create($dados);

            if (!empty($dados['photo'])) {
                $user->photo = UserPhoto::create(['user_id' => $user->id, 'url' => $dados['photo']]);
            }

            return new JsonResponse($user, JsonResponse::HTTP_CREATED);
        } catch (ValidationException $e) {
            return new JsonResponse(['error' => $e->getMessage()], JsonResponse::HTTP_BAD_REQUEST);
        } catch (Exception $e) {
            return new JsonResponse(['error' => ErrorMessageService::handleException($e)], JsonResponse::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    private function getPathPhotoUpload(string $p) : string {
        $path = DIRECTORY_SEPARATOR . $p;
        $path .= DIRECTORY_SEPARATOR . date('Y');
        $path .= DIRECTORY_SEPARATOR . date('m');
        $path .= DIRECTORY_SEPARATOR . date('d');

        return $path;
    }

    /**
     * Display the specified resource.
     */
    public function show(User $user)
    {
        if (empty($user->apelido)) {
            $user->apelido = explode(' ', $user->name)[0];
        }

        $user = User::with('photo')->find($user->id);

        return new JsonResponse($user);
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, User $user)
    {
        try {
            $request->validate([
                'name' =>'string|min:3|max:250',
                'apelido' => 'string|min:3|max:45',
                'email' => [
                    'email',
                    'max:250',
                    Rule::unique('users')->ignore($user->id)
                ],
                'photo' => [
                    File::types(['jpg', 'jpeg', 'png', 'gif'])->max(12 * 1024),
                ],
            ]);

            if ($request->has('name')) {
                $user->name = $request->input('name');
            }

            if ($request->has('apelido')) {
                $user->apelido = $request->input('apelido');
            }

            if ($request->has('email')) {
                $user->email = $request->input('email');
            }

            if ($request->hasFile('photo')) {
                $file = $request->file('photo');
                $originalFileName = $file->getClientOriginalName();

                $extension      = pathinfo($originalFileName, PATHINFO_EXTENSION);
                $basename       = bin2hex(random_bytes(8));
                $newFilename    = date('U'). sprintf('%s.%0.8s', $basename, $extension);
                $directory      = $this->getPathPhotoUpload('user_photo');

                $file->storeAs($directory, $newFilename, 'private');


                $userPhoto = UserPhoto::where('user_id', $user->id)->first();
                if (!empty($userPhoto)) {
                    $userPhoto->url = $directory. DIRECTORY_SEPARATOR. $newFilename;
                    $userPhoto->save();
                } else {
                    UserPhoto::create(['user_id' => $user->id, 'url' => $directory. DIRECTORY_SEPARATOR. $newFilename]);
                }
            }

            $user->save();
            $user = User::with('photo')->find($user->id);
            return new JsonResponse($user);
        } catch (ValidationException $e) {
            return new JsonResponse(['error' => $e->getMessage()], JsonResponse::HTTP_BAD_REQUEST);
        } catch (Exception $e) {
            return new JsonResponse(['error' => ErrorMessageService::handleException($e)], JsonResponse::HTTP_INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(User $user)
    {
        $user->delete();
        return new JsonResponse(null, JsonResponse::HTTP_NO_CONTENT);
    }

    public function photo(User $user) {
        try {

            $photo = UserPhoto::where('user_id', $user->id)->get();
            if ($photo->isEmpty()) {
                abort(404);
            }
            $photo = $photo->first();

            $pathToFile = realpath(storage_path('app/private') . $photo->url);
            if (!file_exists($pathToFile)) {
                abort(404);
            }

            $fileName = pathinfo($pathToFile, PATHINFO_BASENAME);

            return response()->download($pathToFile, $fileName, ['Cache-Control' => 'no-cache, no-store, must-revalidate']);
        } catch (Exception $e) {
            return new JsonResponse(
                ['errors' => $e->getMessage()],
                JsonResponse::HTTP_INTERNAL_SERVER_ERROR
            );
        }
    }
}
